import 'package:dartz/dartz.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<String, WeatherEntity>> getWeather();
}
