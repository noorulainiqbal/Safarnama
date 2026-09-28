import '../entities/lat_lng_enitity.dart';

class DirectionsEntity {
  final LatLngEntity origin;
  final LatLngEntity destination;
  final List<LatLngEntity> polylinePoints;
  final int distance; // in meters
  final int duration; // in seconds

  DirectionsEntity({
    required this.origin,
    required this.destination,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
  });
}
