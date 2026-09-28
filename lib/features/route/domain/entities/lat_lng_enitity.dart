class LatLngEntity {
  final double latitude;
  final double longitude;

  const LatLngEntity({required this.latitude, required this.longitude});

  @override
  String toString() => '$latitude,$longitude';
}
