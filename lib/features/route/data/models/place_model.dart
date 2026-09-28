import '../../domain/entities/lat_lng_enitity.dart';
import '../../domain/entities/place_enitity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel({
    required super.id,
    required super.name,
    super.address,
    required super.location,
    required super.category,
  });

  factory PlaceModel.fromGeoapifyJson(Map<String, dynamic> json) {
    final properties = json['properties'];
    final geometry = json['geometry'];

    // Determine category
    PlaceCategory category = PlaceCategory.destination;
    final categories = properties['categories'] as List? ?? [];

    if (categories.contains('catering.restaurant')) {
      category = PlaceCategory.food;
    } else if (categories.contains('commercial.shopping_mall')) {
      category = PlaceCategory.shopping;
    }

    return PlaceModel(
      id:
          properties['place_id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name:
          properties['name'] ?? properties['address_line1'] ?? 'Unknown Place',
      address: properties['formatted'],
      location: LatLngEntity(
        latitude: geometry['coordinates'][1],
        longitude: geometry['coordinates'][0],
      ),
      category: category,
    );
  }

  factory PlaceModel.fromGooglePlacesJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['place_id'],
      name: json['name'],
      address: json['vicinity'],
      location: LatLngEntity(
        latitude: json['geometry']['location']['lat'],
        longitude: json['geometry']['location']['lng'],
      ),
      category: _determineCategory(json['types']),
    );
  }

  static PlaceCategory _determineCategory(List<dynamic> types) {
    if (types.contains('restaurant') ||
        types.contains('food') ||
        types.contains('cafe')) {
      return PlaceCategory.food;
    } else if (types.contains('shopping_mall') ||
        types.contains('department_store')) {
      return PlaceCategory.shopping;
    } else if (types.contains('gas_station')) {
      return PlaceCategory.gasStation;
    }
    return PlaceCategory.destination;
  }
}
