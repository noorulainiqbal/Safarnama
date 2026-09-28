// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/place_enitity.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/usecases/get_route_use_case.dart';
import '../../data/datasource/location_data_source.dart';

class RouteProvider extends ChangeNotifier {
  final GetRouteUseCase getRouteUseCase;

  // TextEditingController for destination input
  final TextEditingController destinationController = TextEditingController();

  RouteProvider(this.getRouteUseCase);

  // Map State
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;

  String? _currentAddress;
  String? get currentAddress => _currentAddress;

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  final Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  // Location State
  bool _isLocationLoading = false;
  bool get isLocationLoading => _isLocationLoading;

  bool _locationPermissionGranted = false;
  bool get locationPermissionGranted => _locationPermissionGranted;

  bool _locationServicesEnabled = false;
  bool get locationServicesEnabled => _locationServicesEnabled;

  String? _locationError;
  String? get locationError => _locationError;

  // Route State
  final List<PlaceCategory> _selectedCategories = [PlaceCategory.food];
  List<PlaceCategory> get selectedCategories => _selectedCategories;

  String get destination => destinationController.text;

  RouteEntity? _route;
  RouteEntity? get route => _route;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Default fallback location (Lahore)
  static const LatLng _defaultLocation = LatLng(31.5204, 74.3587);
  static const String _defaultAddress = 'Lahore, Pakistan';

  // Initialize
  Future<void> initialize() async {
    await _checkLocationStatus();
    await _loadLastKnownLocation();
  }

  // Check location status
  Future<void> _checkLocationStatus() async {
    try {
      _locationServicesEnabled = await Geolocator.isLocationServiceEnabled();

      final permission = await Geolocator.checkPermission();
      _locationPermissionGranted =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      notifyListeners();
    } catch (e) {
      print('Error checking location status: $e');
    }
  }

  // Load last known location from SharedPreferences
  Future<void> _loadLastKnownLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationString = prefs.getString('last_known_location');
      final address = prefs.getString('last_known_address');

      if (locationString != null) {
        final parts = locationString.split(',');
        if (parts.length == 2) {
          final lat = double.tryParse(parts[0]);
          final lng = double.tryParse(parts[1]);

          if (lat != null && lng != null) {
            _currentLocation = LatLng(lat, lng);
            _currentAddress = address ?? 'Last Known Location';
            _centerMap();
            notifyListeners();
            return;
          }
        }
      }

      // Fallback to default location
      _currentLocation = _defaultLocation;
      _currentAddress = _defaultAddress;
      _centerMap();
      notifyListeners();
    } catch (e) {
      print('Error loading last known location: $e');
      _currentLocation = _defaultLocation;
      _currentAddress = _defaultAddress;
      _centerMap();
      notifyListeners();
    }
  }

  // Map Methods
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Center map after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _centerMap();
    });
  }

  Future<void> getCurrentLocation() async {
    _isLocationLoading = true;
    _locationError = null;
    notifyListeners();

    try {
      final locationDataSource = LocationDataSource();
      final currentPlace = await locationDataSource.getCurrentLocation();

      _currentLocation = LatLng(
        currentPlace.location.latitude,
        currentPlace.location.longitude,
      );
      _currentAddress = currentPlace.address ?? 'Current Location';

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_known_location',
        '${_currentLocation!.latitude},${_currentLocation!.longitude}',
      );
      if (currentPlace.address != null) {
        await prefs.setString('last_known_address', currentPlace.address!);
      }

      _centerMap();
      _addCurrentLocationMarker();

      // Update location status
      _locationPermissionGranted = true;
      _locationServicesEnabled = true;
    } catch (e) {
      _locationError = e.toString();

      // Try to get last known position from device
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          _currentLocation = LatLng(
            lastPosition.latitude,
            lastPosition.longitude,
          );
          _currentAddress = 'Last Known Position';
          _centerMap();
          _addCurrentLocationMarker();
        }
      } catch (e2) {
        print('Error getting last known position: $e2');
      }
    } finally {
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  void _centerMap() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 13),
      );
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: _currentAddress,
          ),
          zIndexInt: 1000, // Ensure it's on top
        ),
      );
      notifyListeners();
    }
  }

  // Open location settings
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
      // Re-check status after returning
      await Future.delayed(const Duration(seconds: 1));
      await _checkLocationStatus();
    } catch (e) {
      print('Error opening location settings: $e');
    }
  }

  // Open app settings for permissions
  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
      // Re-check status after returning
      await Future.delayed(const Duration(seconds: 1));
      await _checkLocationStatus();
    } catch (e) {
      print('Error opening app settings: $e');
    }
  }

  void toggleCategory(PlaceCategory category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void updateDestination(String value) {
    // This method is no longer needed as we're using controller directly
    // But keeping it for compatibility
    notifyListeners();
  }

  Future<void> startJourney() async {
    final destinationText = destinationController.text.trim();

    if (destinationText.isEmpty) {
      _error = 'Please enter a destination';
      notifyListeners();
      return;
    }

    if (_currentLocation == null) {
      _error = 'Please enable location services';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getRouteUseCase.execute(
      destination: destinationText,
      categories: _selectedCategories,
    );

    _isLoading = false;

    result.fold(
      (failure) {
        _error = failure;
        _route = null;
        _markers.clear();
        _polylines.clear();
      },
      (route) {
        _route = route;
        _error = null;
        _addMarkersFromRoute(route);
        _addPolylineFromRoute(route);
        _fitBoundsToRoute(route);
      },
    );

    notifyListeners();
  }

  void clearError() {
    _error = null;
    _locationError = null;
    notifyListeners();
  }

  void disposeMap() {
    _mapController?.dispose();
    _mapController = null;
    destinationController.dispose();
  }

  void _addMarkersFromRoute(RouteEntity route) {
    _markers.clear();

    // Add current location marker
    if (_currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'You are here'),
        ),
      );
    }

    // Add destination marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          route.destination.location.latitude,
          route.destination.location.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: route.destination.name),
      ),
    );

    // Add waypoint markers
    for (int i = 0; i < route.waypoints.length; i++) {
      final waypoint = route.waypoints[i];
      final markerColor = waypoint.category == PlaceCategory.food
          ? BitmapDescriptor.hueGreen
          : BitmapDescriptor.hueOrange;

      _markers.add(
        Marker(
          markerId: MarkerId('waypoint_$i'),
          position: LatLng(
            waypoint.location.latitude,
            waypoint.location.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
          infoWindow: InfoWindow(
            title: waypoint.name,
            snippet: waypoint.category == PlaceCategory.food
                ? 'Food 🍔'
                : 'Shopping 🛍️',
          ),
        ),
      );
    }
  }

  void _addPolylineFromRoute(RouteEntity route) {
    _polylines.clear();

    final polylinePoints = route.polylinePoints.map((point) {
      return LatLng(point.latitude, point.longitude);
    }).toList();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylinePoints,
        color: const Color(0xFF49111C),
        width: 4,
      ),
    );
  }

  LatLngBounds _calculateBounds(RouteEntity route) {
    if (_currentLocation == null) {
      return LatLngBounds(
        southwest: const LatLng(0, 0),
        northeast: const LatLng(0, 0),
      );
    }

    double minLat = _currentLocation!.latitude;
    double maxLat = _currentLocation!.latitude;
    double minLng = _currentLocation!.longitude;
    double maxLng = _currentLocation!.longitude;

    // Include destination
    minLat = minLat < route.destination.location.latitude
        ? minLat
        : route.destination.location.latitude;
    maxLat = maxLat > route.destination.location.latitude
        ? maxLat
        : route.destination.location.latitude;
    minLng = minLng < route.destination.location.longitude
        ? minLng
        : route.destination.location.longitude;
    maxLng = maxLng > route.destination.location.longitude
        ? maxLng
        : route.destination.location.longitude;

    // Include waypoints
    for (final waypoint in route.waypoints) {
      minLat = minLat < waypoint.location.latitude
          ? minLat
          : waypoint.location.latitude;
      maxLat = maxLat > waypoint.location.latitude
          ? maxLat
          : waypoint.location.latitude;
      minLng = minLng < waypoint.location.longitude
          ? minLng
          : waypoint.location.longitude;
      maxLng = maxLng > waypoint.location.longitude
          ? maxLng
          : waypoint.location.longitude;
    }

    // Add padding
    const padding = 0.01;
    return LatLngBounds(
      southwest: LatLng(minLat - padding, minLng - padding),
      northeast: LatLng(maxLat + padding, maxLng + padding),
    );
  }

  void _fitBoundsToRoute(RouteEntity route) {
    if (_mapController == null) return;

    final bounds = _calculateBounds(route);
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }
}
