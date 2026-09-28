import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecase/get_weather_usecase.dart';

class WeatherNotifier extends ChangeNotifier {
  final GetWeatherUseCase getWeatherUseCase;

  WeatherNotifier({required this.getWeatherUseCase});

  WeatherEntity? weather;
  String? error;
  bool isLoading = false;

  Future<void> fetchWeather() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await getWeatherUseCase();

    result.fold(
      (failure) {
        error = failure;
        weather = null;
      },
      (data) {
        weather = data;
        error = null;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
