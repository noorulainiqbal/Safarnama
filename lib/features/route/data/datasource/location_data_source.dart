import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/place_enitity.dart';
import '../../domain/entities/lat_lng_enitity.dart';
import '../models/place_model.dart';

class LocationDataSource {
  static const String _lastKnownLocationKey = 'last_known_location';
  static const String _lastKnownAddressKey = 'last_known_address';

  Future<PlaceEntity> getCurrentLocation() async {
    try {
      // First check permissions
      await _checkLocationPermissions();

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'en_US',
      );

      String address = '';
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        address = _formatAddress(placemark);
      }

      // Save to SharedPreferences for future use
      await _saveLocationToPrefs(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      return PlaceModel(
        id: 'current_location',
        name: 'Current Location',
        address: address.isNotEmpty ? address : null,
        location: LatLngEntity(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        category: PlaceCategory.userLocation,
      );
    } catch (e) {
      // If getting current location fails, try to get last known location from SharedPreferences
      final lastLocation = await _getLastKnownLocationFromPrefs();
      if (lastLocation != null) {
        return lastLocation;
      }

      throw Exception('Failed to get current location: $e');
    }
  }

  Future<PlaceEntity?> getLastKnownLocation() async {
    return await _getLastKnownLocationFromPrefs();
  }

  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  Future<void> saveManualLocation(LatLngEntity location, String address) async {
    await _saveLocationToPrefs(
      latitude: location.latitude,
      longitude: location.longitude,
      address: address,
    );
  }

  // Permission Handling
  Future<void> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. '
        'Please enable them in app settings.',
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. '
          'Please enable them in app settings.',
        );
      }
    }
  }

  // SharedPreferences Methods
  Future<void> _saveLocationToPrefs({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastKnownLocationKey, '$latitude,$longitude');
    await prefs.setString(_lastKnownAddressKey, address);
  }

  Future<PlaceEntity?> _getLastKnownLocationFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final locationString = prefs.getString(_lastKnownLocationKey);
    final address = prefs.getString(_lastKnownAddressKey);

    if (locationString != null) {
      final parts = locationString.split(',');
      if (parts.length == 2) {
        final latitude = double.tryParse(parts[0]);
        final longitude = double.tryParse(parts[1]);

        if (latitude != null && longitude != null) {
          return PlaceModel(
            id: 'last_known_location',
            name: 'Last Known Location',
            address: address,
            location: LatLngEntity(latitude: latitude, longitude: longitude),
            category: PlaceCategory.userLocation,
          );
        }
      }
    }

    return null;
  }

  String _formatAddress(Placemark placemark) {
    final addressParts = [
      placemark.street,
      placemark.subLocality,
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ];

    return addressParts
        .where((part) => part != null && part.isNotEmpty)
        .join(', ');
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Open app settings for permission management
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
