// ignore_for_file: avoid_print, avoid_types_as_parameter_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/travel_story_entity.dart';
import '../model/chat_message_model.dart';
import '../model/travel_story_model.dart';

class ChatbotRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final String geminiApiKey;
  late final GenerativeModel _model;

  ChatbotRemoteDataSource({
    required this.firestore,
    required this.auth,
    required this.geminiApiKey,
  }) {
    print(
      'Initializing ChatbotRemoteDataSource with API key: ${geminiApiKey.substring(0, 10)}...',
    );
    _initializeModel();
  }

  void _initializeModel() {
    try {
      _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: geminiApiKey);
      print('Gemini model initialized successfully');
    } catch (e) {
      print('Error initializing Gemini model: $e');
      rethrow;
    }
  }

  CollectionReference get _chatMessagesCollection =>
      firestore.collection('chat_messages');

  CollectionReference get _travelStoriesCollection =>
      firestore.collection('travel_stories');

  // Chat Operations
  Future<ChatMessageEntity> sendMessage({
    required String userId,
    required String message,
    String? location,
  }) async {
    try {
      print('Sending message: $message');

      // Generate response using Gemini API
      final response = await _generateGeminiResponse(message, location);
      print(
        'Generated response: ${response.substring(0, response.length > 100 ? 100 : response.length)}...',
      );

      // Create chat message
      final chatMessage = ChatMessageEntity.create(
        userId: userId,
        message: message,
        response: response,
        isUserMessage: false, // This is the bot's response
        location: location,
        metadata: {
          'model': 'gemini-2.0-flash',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Save to Firestore
      final docRef = await _chatMessagesCollection.add(
        ChatMessageModel.fromEntity(chatMessage).toFirestore(),
      );

      print('Message saved to Firestore with ID: ${docRef.id}');

      return chatMessage.copyWith(id: docRef.id);
    } catch (e, stackTrace) {
      print('Error in sendMessage: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to send message: $e');
    }
  }

  Future<String> _generateGeminiResponse(
    String message,
    String? location,
  ) async {
    try {
      print('Calling Gemini API...');
      print('Model instance check: ${_model.toString()}');

      // Enhanced prompt for cultural storytelling
      final prompt =
          """
You are a cultural tour guide and storyteller. A traveler is asking about: "$message"

If this is a location or tourist attraction, provide:
1. An immersive travel narrative/story about the place
2. 3-5 fun/interesting facts
3. Cultural tips for visiting
4. Must-see spots or hidden gems
5. Local customs or etiquette to be aware of

If it's not a specific location, respond as a helpful travel guide who provides cultural insights and travel tips.

Make the response engaging, informative, and personal. Use markdown formatting for better readability.
""";

      final content = [Content.text(prompt)];

      print('About to call generateContent...');
      final response = await _model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        ),
      );

      print('Received response from Gemini');
      final text = response.text;
      if (text != null && text.isNotEmpty) {
        print('Successfully generated response with ${text.length} characters');
        return text;
      }

      print('Empty response from Gemini');
      return _getFallbackResponse(message);
    } catch (e, stackTrace) {
      print('Exception in _generateGeminiResponse: $e');
      print('Stack trace: $stackTrace');
      return _getFallbackResponse(message);
    }
  }

  String _getFallbackResponse(String message) {
    return """
I'd love to tell you a story about $message! As a cultural tour guide, I specialize in bringing destinations to life with immersive narratives and cultural insights.

**Here's what I know about $message:**
- It's a fascinating destination with rich cultural heritage
- There are unique traditions and customs worth exploring
- The local cuisine offers authentic flavors
- The architecture tells stories of different eras

**Cultural Tip:** Always try to learn a few basic phrases in the local language - it opens doors to authentic experiences!

**Pro Traveler Advice:** Visit during off-peak hours to avoid crowds and get a more intimate experience with the local culture.

Would you like me to dive deeper into any specific aspect of $message?""";
  }

  Future<List<ChatMessageEntity>> getChatHistory({
    required String userId,
    int limit = 50,
  }) async {
    try {
      final querySnapshot = await _chatMessagesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        return ChatMessageModel.fromFirestore(doc, null);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  Stream<List<ChatMessageEntity>> streamChatHistory(String userId) {
    try {
      return _chatMessagesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ChatMessageModel.fromFirestore(doc, null);
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to stream chat history: $e');
    }
  }

  Future<void> clearChatHistory(String userId) async {
    try {
      // Get all messages for user
      final querySnapshot = await _chatMessagesCollection
          .where('userId', isEqualTo: userId)
          .get();

      // Batch delete
      final batch = firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }

  // Travel Stories
  Future<TravelStoryEntity> generateTravelStory({
    required String userId,
    required String location,
  }) async {
    try {
      // Generate story using Gemini API
      final story = await _generateTravelStoryContent(location);

      // Parse the response to extract structured data
      final parsedData = _parseTravelStoryResponse(story);

      // Create travel story entity
      final travelStory = TravelStoryEntity.create(
        userId: userId,
        location: location,
        story: parsedData['story'] ?? story,
        funFacts: List<String>.from(parsedData['funFacts'] ?? []),
        culturalTips: List<String>.from(parsedData['culturalTips'] ?? []),
        mustVisitPlaces: List<String>.from(parsedData['mustVisitPlaces'] ?? []),
        additionalInfo: Map<String, dynamic>.from(
          parsedData['additionalInfo'] ?? {},
        ),
      );

      // Save to Firestore
      final docRef = await _travelStoriesCollection.add(
        TravelStoryModel.fromEntity(travelStory).toFirestore(),
      );

      return travelStory.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to generate travel story: $e');
    }
  }

  Future<String> _generateTravelStoryContent(String location) async {
    final prompt =
        """
Create an immersive travel story and cultural guide about $location.

Structure your response as a JSON object with the following format:
{
  "story": "An immersive narrative about visiting $location",
  "funFacts": ["Fact 1", "Fact 2", "Fact 3", "Fact 4", "Fact 5"],
  "culturalTips": ["Tip 1", "Tip 2", "Tip 3", "Tip 4"],
  "mustVisitPlaces": ["Place 1", "Place 2", "Place 3", "Place 4"],
  "additionalInfo": {
    "bestTimeToVisit": "Time period",
    "localCuisine": "Food specialties",
    "languageTips": "Useful phrases",
    "culturalEtiquette": "Important customs"
  }
}

Make the story engaging, personal, and rich with cultural insights. Include sensory details (sights, sounds, smells) and historical context.
""";

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.8,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 4096,
        ),
      );

      final text = response.text;
      if (text != null && text.isNotEmpty) {
        return text;
      }

      // Fallback story
      return _getFallbackTravelStory(location);
    } catch (e) {
      print('Error generating travel story: $e');
      return _getFallbackTravelStory(location);
    }
  }

  String _getFallbackTravelStory(String location) {
    return '''
{
  "story": "As you approach $location, you're immediately struck by the blend of ancient traditions and modern vitality. The air carries scents of local spices and street food, while vibrant colors from market stalls catch your eye at every turn. Locals greet you with warm smiles, embodying the famous hospitality of this region. Walking through the historic quarters feels like stepping back in time, with architecture that tells stories of empires, traders, and cultural exchange spanning centuries. In the evenings, the city transforms with lively music and dance performances that showcase local artistic traditions passed down through generations.",
  "funFacts": [
    "$location is home to one of the oldest continuously inhabited cities in the world",
    "The local cuisine features a unique blend of spices found nowhere else",
    "A UNESCO World Heritage site can be found within the city limits",
    "The traditional clothing features intricate patterns with symbolic meanings",
    "Local festivals attract visitors from around the globe each year"
  ],
  "culturalTips": [
    "Always remove shoes before entering homes or religious sites",
    "Learn basic greetings in the local language - it's greatly appreciated",
    "Bargaining is expected in markets but do so respectfully",
    "Dress modestly when visiting religious or traditional areas",
    "Accept offers of tea or food as a sign of hospitality"
  ],
  "mustVisitPlaces": [
    "The historic old town with its winding alleys",
    "The main cultural museum showcasing local heritage",
    "The bustling central market for authentic experiences",
    "The hilltop viewpoint for panoramic city views",
    "The traditional crafts district for local artisans"
  ],
  "additionalInfo": {
    "bestTimeToVisit": "Spring or Autumn for pleasant weather",
    "localCuisine": "Rich stews, flatbreads, and sweet pastries",
    "languageTips": "Hello = Salam, Thank you = Shukriya, How much = Kitna?",
    "culturalEtiquette": "Use your right hand for eating and greeting"
  }
}''';
  }

  Map<String, dynamic> _parseTravelStoryResponse(String response) {
    try {
      // Try to parse as JSON
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}');

      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonStr = response.substring(jsonStart, jsonEnd + 1);
        return jsonDecode(jsonStr);
      }
    } catch (e) {
      print('Failed to parse JSON response: $e');
    }

    // Return default structure if parsing fails
    return {
      'story': response,
      'funFacts': [
        'Interesting cultural fact about the destination',
        'Historical significance of the location',
        'Unique local traditions',
        'Architectural highlights',
        'Culinary specialties',
      ],
      'culturalTips': [
        'Respect local customs and traditions',
        'Learn basic greetings in local language',
        'Dress appropriately for cultural sites',
        'Be mindful of photography restrictions',
        'Support local businesses and artisans',
      ],
      'mustVisitPlaces': [
        'Historical landmarks',
        'Cultural museums',
        'Local markets',
        'Natural attractions',
        'Traditional neighborhoods',
      ],
      'additionalInfo': {
        'bestTimeToVisit': 'Check local seasons and festivals',
        'localCuisine': 'Try authentic local dishes',
        'languageTips': 'Learn basic phrases for better interaction',
        'culturalEtiquette': 'Observe and follow local customs',
      },
    };
  }

  Future<List<TravelStoryEntity>> getUserTravelStories(String userId) async {
    try {
      final querySnapshot = await _travelStoriesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return TravelStoryModel.fromFirestore(doc, null);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get travel stories: $e');
    }
  }

  // Analytics
  Future<int?> getTotalMessages(String userId) async {
    try {
      final querySnapshot = await _chatMessagesCollection
          .where('userId', isEqualTo: userId)
          .count()
          .get();

      return querySnapshot.count;
    } catch (e) {
      throw Exception('Failed to get total messages: $e');
    }
  }

  Future<Map<String, dynamic>> getChatAnalytics(String userId) async {
    try {
      final snapshot = await _chatMessagesCollection
          .where('userId', isEqualTo: userId)
          .get();

      final messages = snapshot.docs;
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      int messagesLast30Days = 0;
      final Map<String, int> locationFrequency = {};

      for (final doc in messages) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = (data['timestamp'] as Timestamp).toDate();

        if (timestamp.isAfter(thirtyDaysAgo)) {
          messagesLast30Days++;
        }

        final location = data['location'];
        if (location != null) {
          locationFrequency[location] = (locationFrequency[location] ?? 0) + 1;
        }
      }

      return {
        'totalMessages': messages.length,
        'messagesLast30Days': messagesLast30Days,
        'mostFrequentLocations': locationFrequency,
        'averageResponseLength': messages.isNotEmpty
            ? messages.fold(0, (sum, doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return sum + (data['response']?.toString().length ?? 0);
                  }) /
                  messages.length
            : 0,
      };
    } catch (e) {
      throw Exception('Failed to get chat analytics: $e');
    }
  }

  // Preferences
  Future<Map<String, dynamic>> getChatbotPreferences(String userId) async {
    try {
      final doc = await firestore
          .collection('chatbot_preferences')
          .doc(userId)
          .get();

      if (doc.exists) {
        return Map<String, dynamic>.from(doc.data()!);
      }

      // Default preferences
      return {
        'language': 'English',
        'responseLength': 'detailed',
        'includeFunFacts': true,
        'includeCulturalTips': true,
        'includeImages': true,
        'notificationEnabled': true,
        'theme': 'light',
        'createdAt': FieldValue.serverTimestamp(),
      };
    } catch (e) {
      throw Exception('Failed to get preferences: $e');
    }
  }

  Future<Map<String, dynamic>> updateChatbotPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      await firestore
          .collection('chatbot_preferences')
          .doc(userId)
          .set(preferences, SetOptions(merge: true));

      return preferences;
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }
}
