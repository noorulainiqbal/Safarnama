class ChatMessageEntity {
  final String id;
  final String userId;
  final String message;
  final String response;
  final bool isUserMessage;
  final DateTime timestamp;
  final String? location;
  final Map<String, dynamic>? metadata;

  ChatMessageEntity({
    required this.id,
    required this.userId,
    required this.message,
    required this.response,
    required this.isUserMessage,
    required this.timestamp,
    this.location,
    this.metadata,
  });

  // For new messages
  ChatMessageEntity.create({
    required this.userId,
    required this.message,
    required this.response,
    required this.isUserMessage,
    this.location,
    this.metadata,
  }) : id = '',
       timestamp = DateTime.now();

  // Copy with
  ChatMessageEntity copyWith({
    String? id,
    String? userId,
    String? message,
    String? response,
    bool? isUserMessage,
    DateTime? timestamp,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      response: response ?? this.response,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
    );
  }
}

class ChatHistoryEntity {
  final String userId;
  final List<ChatMessageEntity> messages;
  final DateTime lastUpdated;
  final int totalMessages;

  ChatHistoryEntity({
    required this.userId,
    required this.messages,
    required this.lastUpdated,
    required this.totalMessages,
  });
}
