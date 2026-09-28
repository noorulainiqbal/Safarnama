import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionHandler {
  static Future<bool> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, can't request permissions
      return false;
    }

    // Check permission status using permission_handler
    var status = await Permission.location.status;

    if (status.isDenied) {
      // Request the permission
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // The user opted to never see the permission request dialog for this app.
      // You can redirect them to app settings
      return false;
    }

    return status.isGranted || status.isLimited;
  }

  static Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted || status.isLimited;
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
