// features/itinerary/data/models/schedule_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required super.id,
    required super.title,
    required super.location,
    required super.date,
    required super.time,
    super.imageUrl,
    super.notes,
    required super.createdAt,
    super.isCompleted,
    super.completedAt,
  });

  factory ScheduleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ScheduleModel(
      id: doc.id,
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      imageUrl: data['imageUrl'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'location': location,
      'date': Timestamp.fromDate(date),
      'time': time,
      'imageUrl': imageUrl,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
    };
  }

  factory ScheduleModel.fromEntity(ScheduleEntity entity) {
    return ScheduleModel(
      id: entity.id,
      title: entity.title,
      location: entity.location,
      date: entity.date,
      time: entity.time,
      imageUrl: entity.imageUrl,
      notes: entity.notes,
      createdAt: entity.createdAt,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
    );
  }

  ScheduleEntity toEntity() => this;
}
