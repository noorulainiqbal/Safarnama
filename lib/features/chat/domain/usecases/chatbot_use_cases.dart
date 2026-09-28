import 'package:dartz/dartz.dart';
import '../entities/chat_message_entity.dart';
import '../entities/travel_story_entity.dart';
import '../repository/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<String, ChatMessageEntity>> execute({
    required String userId,
    required String message,
    String? location,
  }) {
    return repository.sendMessage(
      userId: userId,
      message: message,
      location: location,
    );
  }
}

class GetChatHistoryUseCase {
  final ChatbotRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<Either<String, List<ChatMessageEntity>>> execute({
    required String userId,
    int limit = 50,
  }) {
    return repository.getChatHistory(userId: userId, limit: limit);
  }
}

class StreamChatHistoryUseCase {
  final ChatbotRepository repository;

  StreamChatHistoryUseCase(this.repository);

  Future<Either<String, Stream<List<ChatMessageEntity>>>> execute(
    String userId,
  ) {
    return repository.streamChatHistory(userId);
  }
}

class ClearChatHistoryUseCase {
  final ChatbotRepository repository;

  ClearChatHistoryUseCase(this.repository);

  Future<Either<String, void>> execute(String userId) {
    return repository.clearChatHistory(userId);
  }
}

class GenerateTravelStoryUseCase {
  final ChatbotRepository repository;

  GenerateTravelStoryUseCase(this.repository);

  Future<Either<String, TravelStoryEntity>> execute({
    required String userId,
    required String location,
  }) {
    return repository.generateTravelStory(userId: userId, location: location);
  }
}

class GetUserTravelStoriesUseCase {
  final ChatbotRepository repository;

  GetUserTravelStoriesUseCase(this.repository);

  Future<Either<String, List<TravelStoryEntity>>> execute(String userId) {
    return repository.getUserTravelStories(userId);
  }
}
