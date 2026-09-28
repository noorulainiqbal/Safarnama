import '../../domain/entities/directions_entity.dart';
import '../../domain/entities/lat_lng_enitity.dart';

class DirectionsModel extends DirectionsEntity {
  DirectionsModel({
    required super.origin,
    required super.destination,
    required super.polylinePoints,
    required super.distance,
    required super.duration,
  });

  factory DirectionsModel.fromGoogleJson(Map<String, dynamic> json) {
    final routes = json['routes'] as List;
    if (routes.isEmpty) {
      throw Exception('No routes found');
    }

    final route = routes.first;
    final legs = route['legs'] as List;
    final leg = legs.first;

    // Decode polyline
    final overviewPolyline = route['overview_polyline']['points'];
    final polylinePoints = _decodePolyline(overviewPolyline);

    return DirectionsModel(
      origin: LatLngEntity(
        latitude: leg['start_location']['lat'],
        longitude: leg['start_location']['lng'],
      ),
      destination: LatLngEntity(
        latitude: leg['end_location']['lat'],
        longitude: leg['end_location']['lng'],
      ),
      polylinePoints: polylinePoints,
      distance: leg['distance']['value'],
      duration: leg['duration']['value'],
    );
  }

  static List<LatLngEntity> _decodePolyline(String encoded) {
    List<LatLngEntity> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLngEntity(latitude: lat / 1E5, longitude: lng / 1E5));
    }

    return points;
  }
}
