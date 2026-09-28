import 'package:dartz/dartz.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../datasource/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, WeatherEntity>> getWeather() async {
    try {
      final remoteWeather = await remoteDataSource.getWeather();
      return Right(remoteWeather);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
