import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/route_provider.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RouteProvider>(context);

    return GoogleMap(
      onMapCreated: provider.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: provider.currentLocation ?? const LatLng(31.5204, 74.3587),
        zoom: 13,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: provider.markers,
      polylines: provider.polylines,
    );
  }
}
