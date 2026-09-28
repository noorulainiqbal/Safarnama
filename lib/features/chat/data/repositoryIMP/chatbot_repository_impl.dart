import 'package:dartz/dartz.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/travel_story_entity.dart';
import '../../domain/repository/chatbot_repository.dart';
import '../datasources/chatbot_remote_data_source.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, ChatMessageEntity>> sendMessage({
    required String userId,
    required String message,
    String? location,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        userId: userId,
        message: message,
        location: location,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to send message: $e');
    }
  }

  @override
  Future<Either<String, List<ChatMessageEntity>>> getChatHistory({
    required String userId,
    int limit = 50,
  }) async {
    try {
      final result = await remoteDataSource.getChatHistory(
        userId: userId,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to get chat history: $e');
    }
  }

  @override
  Future<Either<String, Stream<List<ChatMessageEntity>>>> streamChatHistory(
    String userId,
  ) async {
    try {
      final stream = remoteDataSource.streamChatHistory(userId);
      return Right(stream);
    } catch (e) {
      return Left('Failed to stream chat history: $e');
    }
  }

  @override
  Future<Either<String, void>> clearChatHistory(String userId) async {
    try {
      await remoteDataSource.clearChatHistory(userId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to clear chat history: $e');
    }
  }

  @override
  Future<Either<String, TravelStoryEntity>> generateTravelStory({
    required String userId,
    required String location,
  }) async {
    try {
      final result = await remoteDataSource.generateTravelStory(
        userId: userId,
        location: location,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to generate travel story: $e');
    }
  }

  @override
  Future<Either<String, List<TravelStoryEntity>>> getUserTravelStories(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getUserTravelStories(userId);
      return Right(result);
    } catch (e) {
      return Left('Failed to get travel stories: $e');
    }
  }

  @override
  Future<Either<String, int>> getTotalMessages(String userId) async {
    try {
      final result = await remoteDataSource.getTotalMessages(userId);
      return Right(result!);
    } catch (e) {
      return Left('Failed to get total messages: $e');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getChatAnalytics(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getChatAnalytics(userId);
      return Right(result);
    } catch (e) {
      return Left('Failed to get chat analytics: $e');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getChatbotPreferences(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getChatbotPreferences(userId);
      return Right(result);
    } catch (e) {
      return Left('Failed to get chatbot preferences: $e');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> updateChatbotPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final result = await remoteDataSource.updateChatbotPreferences(
        userId: userId,
        preferences: preferences,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to update chatbot preferences: $e');
    }
  }
}
