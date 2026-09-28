import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.userId,
    required super.message,
    required super.response,
    required super.isUserMessage,
    required super.timestamp,
    super.location,
    super.metadata,
  });

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      userId: entity.userId,
      message: entity.message,
      response: entity.response,
      isUserMessage: entity.isUserMessage,
      timestamp: entity.timestamp,
      location: entity.location,
      metadata: entity.metadata,
    );
  }

  factory ChatMessageModel.fromFirestore(
    DocumentSnapshot doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatMessageModel(
      id: doc.id,
      userId: data['userId'],
      message: data['message'],
      response: data['response'] ?? '',
      isUserMessage: data['isUserMessage'] ?? true,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      location: data['location'],
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'message': message,
      'response': response,
      'isUserMessage': isUserMessage,
      'timestamp': Timestamp.fromDate(timestamp),
      if (location != null) 'location': location,
      if (metadata != null) 'metadata': metadata,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
