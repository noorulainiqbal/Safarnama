class TravelStoryEntity {
  final String id;
  final String userId;
  final String location;
  final String story;
  final List<String> funFacts;
  final List<String> culturalTips;
  final List<String> mustVisitPlaces;
  final Map<String, dynamic> additionalInfo;
  final DateTime createdAt;
  final String? imageUrl;

  TravelStoryEntity({
    required this.id,
    required this.userId,
    required this.location,
    required this.story,
    required this.funFacts,
    required this.culturalTips,
    required this.mustVisitPlaces,
    required this.additionalInfo,
    required this.createdAt,
    this.imageUrl,
  });

  // For new stories
  TravelStoryEntity.create({
    required this.userId,
    required this.location,
    required this.story,
    required this.funFacts,
    required this.culturalTips,
    required this.mustVisitPlaces,
    required this.additionalInfo,
    this.imageUrl,
  }) : id = '',
       createdAt = DateTime.now();

  // Copy with method
  TravelStoryEntity copyWith({
    String? id,
    String? userId,
    String? location,
    String? story,
    List<String>? funFacts,
    List<String>? culturalTips,
    List<String>? mustVisitPlaces,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return TravelStoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      story: story ?? this.story,
      funFacts: funFacts ?? this.funFacts,
      culturalTips: culturalTips ?? this.culturalTips,
      mustVisitPlaces: mustVisitPlaces ?? this.mustVisitPlaces,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
