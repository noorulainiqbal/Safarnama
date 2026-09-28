// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import '../../domain/entities/place_enitity.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/entities/directions_entity.dart';
import '../../domain/repository/route_repository.dart';
import '../datasource/google_maps_data_source.dart';
import '../datasource/location_data_source.dart';

class RouteRepositoryImpl implements RouteRepository {
  final GoogleMapsDataSource googleMapsDataSource;
  final LocationDataSource locationDataSource;

  RouteRepositoryImpl({
    required this.googleMapsDataSource,
    required this.locationDataSource,
  });

  @override
  Future<Either<String, PlaceEntity>> getCurrentLocation() async {
    try {
      final location = await locationDataSource.getCurrentLocation();
      return Right(location);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, PlaceEntity>> geocodeLocation(String placeName) async {
    try {
      final place = await googleMapsDataSource.geocodeLocation(placeName);
      return Right(place);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required List<PlaceCategory> categories,
    int radius = 2000,
    int limit = 5,
  }) async {
    try {
      final places = await googleMapsDataSource.getNearbyPlaces(
        latitude: latitude,
        longitude: longitude,
        categories: categories,
        radius: radius,
        limit: limit,
      );
      return Right(places);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DirectionsEntity>> getDirections({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    List<PlaceEntity>? waypoints,
  }) async {
    try {
      final directions = await googleMapsDataSource.getDirections(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
        waypoints: waypoints,
      );
      return Right(directions);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, RouteEntity>> calculateRoute({
    required String destination,
    required List<PlaceCategory> selectedCategories,
  }) async {
    try {
      // Step 1: Get current location
      final currentLocationResult = await getCurrentLocation();
      PlaceEntity origin = await currentLocationResult.fold(
        (error) => throw Exception('Failed to get current location: $error'),
        (location) => location,
      );

      // Step 2: Geocode destination
      final destinationResult = await geocodeLocation(destination);
      PlaceEntity destinationPlace = await destinationResult.fold(
        (error) => throw Exception('Failed to geocode destination: $error'),
        (place) => place,
      );

      // Step 3: Get nearby places if categories selected
      List<PlaceEntity> waypoints = [];
      if (selectedCategories.isNotEmpty) {
        final nearbyResult = await getNearbyPlaces(
          latitude: destinationPlace.location.latitude,
          longitude: destinationPlace.location.longitude,
          categories: selectedCategories,
        );

        waypoints = await nearbyResult.fold((error) {
          print('Warning: Failed to get nearby places: $error');
          return [];
        }, (places) => places);
      }

      // Step 4: Get directions with waypoints
      final directionsResult = await getDirections(
        originLat: origin.location.latitude,
        originLng: origin.location.longitude,
        destLat: destinationPlace.location.latitude,
        destLng: destinationPlace.location.longitude,
        waypoints: waypoints,
      );

      final directions = directionsResult.fold(
        (error) => throw Exception('Failed to get directions: $error'),
        (dir) => dir,
      );

      // Step 5: Create route entity
      final route = RouteEntity(
        origin: origin,
        destination: destinationPlace,
        waypoints: waypoints,
        polylinePoints: directions.polylinePoints,
        distance: directions.distance,
        duration: directions.duration,
      );

      return Right(route);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
