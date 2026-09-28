import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/travel_story_entity.dart';

class TravelStoryModel extends TravelStoryEntity {
  TravelStoryModel({
    required super.id,
    required super.userId,
    required super.location,
    required super.story,
    required super.funFacts,
    required super.culturalTips,
    required super.mustVisitPlaces,
    required super.additionalInfo,
    required super.createdAt,
    super.imageUrl,
  });

  factory TravelStoryModel.fromEntity(TravelStoryEntity entity) {
    return TravelStoryModel(
      id: entity.id,
      userId: entity.userId,
      location: entity.location,
      story: entity.story,
      funFacts: entity.funFacts,
      culturalTips: entity.culturalTips,
      mustVisitPlaces: entity.mustVisitPlaces,
      additionalInfo: entity.additionalInfo,
      createdAt: entity.createdAt,
      imageUrl: entity.imageUrl,
    );
  }

  factory TravelStoryModel.fromFirestore(
    DocumentSnapshot doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return TravelStoryModel(
      id: doc.id,
      userId: data['userId'],
      location: data['location'],
      story: data['story'],
      funFacts: List<String>.from(data['funFacts'] ?? []),
      culturalTips: List<String>.from(data['culturalTips'] ?? []),
      mustVisitPlaces: List<String>.from(data['mustVisitPlaces'] ?? []),
      additionalInfo: Map<String, dynamic>.from(data['additionalInfo'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'location': location,
      'story': story,
      'funFacts': funFacts,
      'culturalTips': culturalTips,
      'mustVisitPlaces': mustVisitPlaces,
      'additionalInfo': additionalInfo,
      'createdAt': Timestamp.fromDate(createdAt),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
