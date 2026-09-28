import 'package:dartz/dartz.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repository/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<Either<String, WeatherEntity>> call() async {
    return await repository.getWeather();
  }
}
