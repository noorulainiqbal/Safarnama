import 'package:dartz/dartz.dart';
import '../entities/chat_message_entity.dart';
import '../entities/travel_story_entity.dart';

abstract class ChatbotRepository {
  // Chat Operations
  Future<Either<String, ChatMessageEntity>> sendMessage({
    required String userId,
    required String message,
    String? location,
  });

  Future<Either<String, List<ChatMessageEntity>>> getChatHistory({
    required String userId,
    int limit = 50,
  });

  Future<Either<String, void>> clearChatHistory(String userId);

  Future<Either<String, Stream<List<ChatMessageEntity>>>> streamChatHistory(
    String userId,
  );

  // Travel Stories
  Future<Either<String, TravelStoryEntity>> generateTravelStory({
    required String userId,
    required String location,
  });

  Future<Either<String, List<TravelStoryEntity>>> getUserTravelStories(
    String userId,
  );

  // Analytics
  Future<Either<String, int>> getTotalMessages(String userId);
  Future<Either<String, Map<String, dynamic>>> getChatAnalytics(String userId);

  // Preferences
  Future<Either<String, Map<String, dynamic>>> getChatbotPreferences(
    String userId,
  );

  Future<Either<String, Map<String, dynamic>>> updateChatbotPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  });
}
