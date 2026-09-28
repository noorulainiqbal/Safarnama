import '../entities/place_enitity.dart';
import '../entities/lat_lng_enitity.dart';

class RouteEntity {
  final PlaceEntity origin;
  final PlaceEntity destination;
  final List<PlaceEntity> waypoints;
  final List<LatLngEntity> polylinePoints;
  final int distance; // in meters
  final int duration; // in seconds

  RouteEntity({
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
  });
}
