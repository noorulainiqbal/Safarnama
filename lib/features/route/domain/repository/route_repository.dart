import 'package:dartz/dartz.dart';
import '../entities/place_enitity.dart';
import '../entities/route_entity.dart';
import '../entities/directions_entity.dart';

abstract class RouteRepository {
  // Location Services
  Future<Either<String, PlaceEntity>> getCurrentLocation();
  Future<Either<String, PlaceEntity>> geocodeLocation(String placeName);

  // Nearby Places
  Future<Either<String, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required List<PlaceCategory> categories,
    int radius = 2000,
    int limit = 5,
  });

  // Directions
  Future<Either<String, DirectionsEntity>> getDirections({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    List<PlaceEntity>? waypoints,
  });

  // Complete Route Calculation
  Future<Either<String, RouteEntity>> calculateRoute({
    required String destination,
    required List<PlaceCategory> selectedCategories,
  });
}
