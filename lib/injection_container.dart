import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'features/weather/data/datasource/weather_remote_datasource.dart';
import 'features/weather/data/repositoryimp/weather_repository_impl.dart';
import 'features/weather/domain/repository/weather_repository.dart';
import 'features/weather/domain/usecase/get_weather_usecase.dart';
import 'features/weather/presentation/provider/weather_provider.dart';

// Route Feature
import 'features/route/data/datasource/google_maps_data_source.dart';
import 'features/route/data/datasource/location_data_source.dart';
import 'features/route/data/repositoryIMP/route_repository_impl.dart';
import 'features/route/domain/repository/route_repository.dart';
import 'features/route/domain/usecases/get_route_use_case.dart';
import 'features/route/presentation/provider/route_provider.dart';

// Chatbot Feature
import 'features/chat/data/datasources/chatbot_remote_data_source.dart';
import 'features/chat/data/repositoryIMP/chatbot_repository_impl.dart';
import 'features/chat/domain/repository/chatbot_repository.dart';
import 'features/chat/domain/usecases/chatbot_use_cases.dart';
import 'features/chat/presentation/provider/chatbot_provider.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // ================= EXTERNAL DEPENDENCIES =================
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => Geolocator());
  getIt.registerLazySingleton(() => http.Client());

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Firebase Services
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // API Keys - Store them centrally
  const String googleMapsApiKey = 'REDACTED_GOOGLE_MAPS_API_KEY';
  const String geminiApiKey =
      'REDACTED_GEMINI_API_KEY'; // Use same key for now, but Gemini has its own API

  // ================= ROUTE FEATURE =================
  // Data Sources
  getIt.registerLazySingleton(
    () => GoogleMapsDataSource(dio: getIt<Dio>(), apiKey: googleMapsApiKey),
  );

  getIt.registerLazySingleton(() => LocationDataSource());

  // Repositories
  getIt.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(
      googleMapsDataSource: getIt<GoogleMapsDataSource>(),
      locationDataSource: getIt<LocationDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetRouteUseCase(getIt<RouteRepository>()));

  // Providers
  getIt.registerLazySingleton(() => RouteProvider(getIt<GetRouteUseCase>()));

  // ================= CHATBOT FEATURE =================
  // Data Sources
  getIt.registerLazySingleton(
    () => ChatbotRemoteDataSource(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
      //dio: getIt<Dio>(),
      geminiApiKey: geminiApiKey, // Using the same API key as requested
    ),
  );

  // Repositories
  getIt.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(getIt<ChatbotRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => SendMessageUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetChatHistoryUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => StreamChatHistoryUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => ClearChatHistoryUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => GenerateTravelStoryUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetUserTravelStoriesUseCase(getIt<ChatbotRepository>()),
  );

  // Providers
  getIt.registerLazySingleton(
    () => ChatbotProvider(
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      getChatHistoryUseCase: getIt<GetChatHistoryUseCase>(),
      streamChatHistoryUseCase: getIt<StreamChatHistoryUseCase>(),
      clearChatHistoryUseCase: getIt<ClearChatHistoryUseCase>(),
      generateTravelStoryUseCase: getIt<GenerateTravelStoryUseCase>(),
      getUserTravelStoriesUseCase: getIt<GetUserTravelStoriesUseCase>(),
    ),
  );

  // Weather Feature
  // Data Sources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt<WeatherRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetWeatherUseCase(getIt<WeatherRepository>()),
  );

  // Providers
  getIt.registerFactory(
    () => WeatherNotifier(getWeatherUseCase: getIt<GetWeatherUseCase>()),
  );
}
