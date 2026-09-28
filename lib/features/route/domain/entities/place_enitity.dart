import '../entities/lat_lng_enitity.dart';

class PlaceEntity {
  final String id;
  final String name;
  final String? address;
  final LatLngEntity location;
  final PlaceCategory category;

  PlaceEntity({
    required this.id,
    required this.name,
    this.address,
    required this.location,
    required this.category,
  });
}

enum PlaceCategory { food, shopping, gasStation, destination, userLocation }
