// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/travel_story_entity.dart';
import '../../domain/usecases/chatbot_use_cases.dart';

class ChatbotProvider extends ChangeNotifier {
  // Use Cases
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final StreamChatHistoryUseCase streamChatHistoryUseCase;
  final ClearChatHistoryUseCase clearChatHistoryUseCase;
  final GenerateTravelStoryUseCase generateTravelStoryUseCase;
  final GetUserTravelStoriesUseCase getUserTravelStoriesUseCase;

  ChatbotProvider({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
    required this.streamChatHistoryUseCase,
    required this.clearChatHistoryUseCase,
    required this.generateTravelStoryUseCase,
    required this.getUserTravelStoriesUseCase,
  });

  // State
  List<ChatMessageEntity> _messages = [];
  List<ChatMessageEntity> get messages => List.unmodifiable(_messages);

  List<TravelStoryEntity> _travelStories = [];
  List<TravelStoryEntity> get travelStories => _travelStories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSending = false;
  bool get isSending => _isSending;

  bool _isGeneratingStory = false;
  bool get isGeneratingStory => _isGeneratingStory;

  String? _error;
  String? get error => _error;

  Stream<List<ChatMessageEntity>>? _chatStream;
  Stream<List<ChatMessageEntity>>? get chatStream => _chatStream;

  final Map<String, dynamic> _analytics = {};
  Map<String, dynamic> get analytics => _analytics;

  // Initialize
  Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    await _loadChatHistory(user.uid);
    // Don't start stream if using manual loading
    // await _startChatStream(user.uid);
  }

  // Load chat history
  Future<void> _loadChatHistory(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getChatHistoryUseCase.execute(userId: userId);

    _isLoading = false;

    result.fold(
      (failure) {
        _error = failure;
        _messages = [];
      },
      (messages) {
        // Messages come from Firestore ordered by timestamp descending
        // Keep them in that order (newest first) since ListView is reversed
        _messages = List.from(messages);
        _error = null;
      },
    );

    notifyListeners();
  }

  // Start real-time chat stream (Optional - use if you want real-time updates)
  // ignore: unused_element
  Future<void> _startChatStream(String userId) async {
    final result = await streamChatHistoryUseCase.execute(userId);

    result.fold((failure) => _error = failure, (stream) {
      _chatStream = stream;
      // Listen to stream updates
      stream.listen((newMessages) {
        _messages = List.from(newMessages);
        notifyListeners();
      });
    });
  }

  // Send message
  Future<void> sendMessage(String message, {String? location}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _error = 'User not logged in';
      notifyListeners();
      return;
    }

    if (message.trim().isEmpty) {
      _error = 'Message cannot be empty';
      notifyListeners();
      return;
    }

    _isSending = true;
    _error = null;
    notifyListeners();

    // Create temporary user message for immediate display
    final tempUserMessage = ChatMessageEntity.create(
      userId: user.uid,
      message: message,
      response: '', // Empty response for user messages
      isUserMessage: true,
      location: location,
      metadata: {'temp': true},
    );

    // Add to the beginning of the list (since reversed ListView shows newest first)
    _messages.insert(0, tempUserMessage);
    notifyListeners();

    // Send to API
    final result = await sendMessageUseCase.execute(
      userId: user.uid,
      message: message,
      location: location,
    );

    _isSending = false;

    result.fold(
      (failure) {
        print('Error sending message: $failure');
        _error = failure;

        // Remove temporary user message
        _messages.removeWhere((m) => m.metadata?['temp'] == true);

        // Add error message
        final errorMessage = ChatMessageEntity.create(
          userId: user.uid,
          message: message,
          response:
              'Sorry, I encountered an error: $failure\nPlease try again.',
          isUserMessage: false,
          location: location,
          metadata: {'error': true},
        );
        _messages.insert(0, errorMessage);
      },
      (responseMessage) {
        print('Message sent successfully');

        // Remove temporary user message
        _messages.removeWhere((m) => m.metadata?['temp'] == true);

        // Add the actual saved messages from Firestore
        // The response should contain both user message and bot response
        // Add them in correct order (bot response first since list is reversed)
        _messages.insert(0, responseMessage);

        // Create and add user message with proper ID
        final actualUserMessage = ChatMessageEntity(
          id: '${responseMessage.id}_user', // Generate related ID
          userId: user.uid,
          message: message,
          response: '',
          isUserMessage: true,
          timestamp: responseMessage.timestamp,
          location: location,
        );
        _messages.insert(1, actualUserMessage); // Add after bot response

        _error = null;
      },
    );

    notifyListeners();
  }

  // Clear chat history
  Future<void> clearChatHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    final result = await clearChatHistoryUseCase.execute(user.uid);

    _isLoading = false;

    result.fold((failure) => _error = failure, (_) {
      _messages.clear();
      _error = null;
    });

    notifyListeners();
  }

  // Generate travel story
  Future<void> generateTravelStory(String location) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || location.trim().isEmpty) return;

    _isGeneratingStory = true;
    _error = null;
    notifyListeners();

    final result = await generateTravelStoryUseCase.execute(
      userId: user.uid,
      location: location,
    );

    _isGeneratingStory = false;

    result.fold((failure) => _error = failure, (story) {
      _travelStories.insert(0, story);
      _error = null;
    });

    notifyListeners();
  }

  // Get user travel stories
  Future<void> loadUserTravelStories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    final result = await getUserTravelStoriesUseCase.execute(user.uid);

    _isLoading = false;

    result.fold(
      (failure) => _error = failure,
      (stories) => _travelStories = stories,
    );

    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Format timestamp
  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  void dispose() {
    _chatStream = null;
    super.dispose();
  }
}
