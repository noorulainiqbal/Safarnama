import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.location,
    required super.rating,
    required super.price,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json, String id) {
    return PlaceModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 150.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'rating': rating,
      'price': price,
    };
  }
}
