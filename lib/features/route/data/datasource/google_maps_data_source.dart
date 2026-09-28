// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../domain/entities/lat_lng_enitity.dart';
import '../../domain/entities/directions_entity.dart';
import '../../domain/entities/place_enitity.dart';
import '../models/direction_model.dart';
import '../models/place_model.dart';

class GoogleMapsDataSource {
  final Dio dio;
  final String apiKey;

  GoogleMapsDataSource({required this.dio, required this.apiKey});

  Future<PlaceEntity> geocodeLocation(String placeName) async {
    try {
      print('🔍 Geocoding request for: $placeName');
      print(
        '🔑 Using API Key: ${apiKey.length > 10 ? apiKey.substring(0, 10) : 'INVALID'}...',
      );

      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {'address': placeName, 'key': apiKey},
      );

      print('📡 Response status: ${response.data['status']}');

      if (response.data['status'] != 'OK') {
        final status = response.data['status'];
        final errorMessage =
            response.data['error_message'] ?? 'No error message';
        print('❌ Geocoding failed: $status - $errorMessage');

        // Provide more specific error messages
        switch (status) {
          case 'ZERO_RESULTS':
            throw Exception(
              'Location "$placeName" not found. Please try:\n- Adding city name (e.g., "Liberty Market, Lahore")\n- Using well-known landmarks\n- Checking spelling',
            );
          case 'REQUEST_DENIED':
            throw Exception(
              'API key issue. Please verify:\n- Geocoding API is enabled\n- API key restrictions are correct\n- Billing is enabled',
            );
          case 'INVALID_REQUEST':
            throw Exception(
              'Invalid location format. Please enter a valid place name.',
            );
          case 'OVER_QUERY_LIMIT':
            throw Exception('Too many requests. Please try again later.');
          default:
            throw Exception(
              'Geocoding error: $status${errorMessage.isNotEmpty ? " - $errorMessage" : ""}',
            );
        }
      }

      if (response.data['results'].isEmpty) {
        throw Exception('No results found for: $placeName');
      }

      final result = response.data['results'][0];
      final geometry = result['geometry']['location'];

      print('✅ Location found: ${result['formatted_address']}');

      return PlaceModel(
        id: result['place_id'],
        name: result['formatted_address'],
        address: result['formatted_address'],
        location: LatLngEntity(
          latitude: geometry['lat'],
          longitude: geometry['lng'],
        ),
        category: PlaceCategory.destination,
      );
    } on DioException catch (e) {
      print('💥 Network error: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server timeout. Please try again.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('💥 Exception in geocoding: $e');
      rethrow;
    }
  }

  Future<List<PlaceEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required List<PlaceCategory> categories,
    int radius = 2000,
    int limit = 5,
  }) async {
    try {
      print('🔍 Searching nearby places at: $latitude, $longitude');

      // Map categories to Google Places types
      final String type = _mapCategoryToGoogleType(categories);
      print('📍 Searching for type: $type');

      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '$latitude,$longitude',
          'radius': radius,
          'type': type,
          'key': apiKey,
        },
      );

      print('📡 Nearby places status: ${response.data['status']}');

      if (response.data['status'] == 'REQUEST_DENIED') {
        print('❌ Places API denied: ${response.data['error_message']}');
        throw Exception(
          'Places API error. Please check API key and enable Places API.',
        );
      }

      if (response.data['status'] != 'OK' &&
          response.data['status'] != 'ZERO_RESULTS') {
        print('❌ Places API error: ${response.data['status']}');
        throw Exception(
          'Failed to fetch nearby places: ${response.data['status']}',
        );
      }

      final List<PlaceEntity> places = [];
      final results = response.data['results'] as List? ?? [];

      print('📦 Found ${results.length} places');

      for (var result in results.take(limit)) {
        try {
          places.add(PlaceModel.fromGooglePlacesJson(result));
        } catch (e) {
          print('⚠️ Error parsing place: $e');
        }
      }

      print('✅ Returning ${places.length} nearby places');
      return places;
    } on DioException catch (e) {
      print('💥 Network error in nearby places: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('💥 Exception in nearby places: $e');
      rethrow;
    }
  }

  Future<DirectionsEntity> getDirections({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    List<PlaceEntity>? waypoints,
  }) async {
    try {
      print(
        '🗺️ Getting directions from ($originLat, $originLng) to ($destLat, $destLng)',
      );
      if (waypoints != null && waypoints.isNotEmpty) {
        print('📍 With ${waypoints.length} waypoints');
      }

      Map<String, dynamic> queryParams = {
        'origin': '$originLat,$originLng',
        'destination': '$destLat,$destLng',
        'key': apiKey,
      };

      // Only add waypoints if there are any
      if (waypoints != null && waypoints.isNotEmpty) {
        final waypointLocations = waypoints
            .map(
              (place) =>
                  '${place.location.latitude},${place.location.longitude}',
            )
            .join('|');
        queryParams['waypoints'] = 'optimize:true|$waypointLocations';
        print('🔄 Waypoints: ${queryParams['waypoints']}');
      }

      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: queryParams,
      );

      print('📡 Directions status: ${response.data['status']}');

      if (response.data['status'] != 'OK') {
        final status = response.data['status'];
        final errorMessage = response.data['error_message'] ?? '';
        print('❌ Directions failed: $status - $errorMessage');

        switch (status) {
          case 'NOT_FOUND':
            throw Exception(
              'Route not found. One or more locations may be invalid.',
            );
          case 'ZERO_RESULTS':
            throw Exception('No route found between these locations.');
          case 'REQUEST_DENIED':
            throw Exception(
              'Directions API error. Please check API key and enable Directions API.',
            );
          case 'OVER_QUERY_LIMIT':
            throw Exception('Too many requests. Please try again later.');
          default:
            throw Exception(
              'Directions error: $status${errorMessage.isNotEmpty ? " - $errorMessage" : ""}',
            );
        }
      }

      final directions = DirectionsModel.fromGoogleJson(response.data);
      print(
        '✅ Route calculated: ${(directions.distance / 1000).toStringAsFixed(1)} km, ${(directions.duration / 60).ceil()} min',
      );

      return directions;
    } on DioException catch (e) {
      print('💥 Network error in directions: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('💥 Exception in directions: $e');
      rethrow;
    }
  }

  String _mapCategoryToGoogleType(List<PlaceCategory> categories) {
    // Default to restaurant if no specific categories
    if (categories.isEmpty) return 'restaurant';

    // Check for food category
    if (categories.contains(PlaceCategory.food)) {
      return 'restaurant';
    }
    // Check for shopping category
    else if (categories.contains(PlaceCategory.shopping)) {
      return 'shopping_mall';
    }
    // Check for gas station category
    else if (categories.contains(PlaceCategory.gasStation)) {
      return 'gas_station';
    }

    return 'restaurant'; // fallback
  }
}
