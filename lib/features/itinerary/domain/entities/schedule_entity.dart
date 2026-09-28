// features/itinerary/domain/entities/schedule_entity.dart

class ScheduleEntity {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final String time;
  final String? imageUrl;
  final String? notes;
  final DateTime createdAt;

  // Completion
  final bool isCompleted;
  final DateTime? completedAt;

  ScheduleEntity({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    this.imageUrl,
    this.notes,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
  });

  ScheduleEntity copyWith({
    String? id,
    String? title,
    String? location,
    DateTime? date,
    String? time,
    String? imageUrl,
    String? notes,
    DateTime? createdAt,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isPast => date.isBefore(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get isUpcoming => date.isAfter(DateTime.now()) && !isToday;
}
