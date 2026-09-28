import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required super.description,
    required super.iconCode,
    required super.temperature,
    required super.cityName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      cityName: json['name'] ?? '',
    );
  }
}
