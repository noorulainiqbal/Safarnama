import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:project/features/intro/presentation/pages/splash.dart';
import 'l10n/app_localizations.dart';
import 'package:project/core/provider/locale_provider.dart';
//==================chat========================
import 'features/chat/presentation/provider/chatbot_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ================= AUTH FEATURE =================
import 'features/auth/presentation/provider/auth_notifier.dart';
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositoryimp/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecase/signup_usecase.dart';
import 'features/auth/domain/usecase/signin_usecase.dart';
import 'features/auth/domain/usecase/signout_usecase.dart';
import 'features/auth/domain/usecase/reset_password_usecase.dart';
import 'features/auth/domain/usecase/get_current_user_usecase.dart';
import 'features/auth/domain/usecase/send_email_verification_usecase.dart';
import 'features/auth/domain/usecase/is_email_verified_usecase.dart';

// ================= ITINERARY FEATURE =================
import 'features/itinerary/data/datasources/itinerary_remote_datasource.dart';
import 'features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'features/itinerary/domain/repositories/itinerary_repository.dart';
import 'features/itinerary/domain/usecases/add_schedule_usecase.dart';
import 'features/itinerary/domain/usecases/delete_schedule_usecase.dart';
import 'features/itinerary/domain/usecases/get_schedules_usecase.dart';
import 'features/itinerary/domain/usecases/update_schedule_usecase.dart';
import 'features/itinerary/presentation/provider/itinerary_provider.dart';

// ================= PROFILE FEATURE =================
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/provider/profile_provider.dart';

// ================= CHECKLIST FEATURE =================
import 'features/checklist/data/datasources/checklist_remote_data_source.dart';
import 'features/checklist/data/repositories/checklist_repository_impl.dart';
import 'features/checklist/domain/repositories/checklist_repository.dart';
import 'features/checklist/domain/usecases/get_checklist_usecase.dart';
import 'features/checklist/domain/usecases/add_update_checklist_item_usecase.dart';
import 'features/checklist/domain/usecases/delete_checklist_item_usecase.dart';
import 'features/checklist/presentation/provider/checklist_provider.dart';

// ================= BUDGET FEATURE =================
import 'features/budget/data/datasources/budget_remote_datasources.dart';
import 'features/budget/data/repositoryIMP/budget_repository_impl.dart';
import 'features/budget/domain/repository/budget_repository.dart';
import 'features/budget/domain/usecases/budget_usecases.dart';
import 'features/budget/presentation/provider/budget_provider.dart';

// ================= TRANSLATOR FEATURE =================
import 'features/translator/data/datasources/translation_remote_datasource.dart';
import 'features/translator/data/repository/translation_repository_impl.dart';
import 'features/translator/domain/repository/translation_repository.dart';
import 'features/translator/domain/usecases/translate_text.dart';
import 'features/translator/presentation/provider/translator_provider.dart';

// ================= PLACES FEATURE =================
import 'features/places/data/datasources/places_remote_data_source.dart';
import 'features/places/data/repositories/places_repository_impl.dart';
import 'features/places/domain/repositories/places_repository.dart';
import 'features/places/domain/usecases/get_places_usecase.dart';
import 'features/places/domain/usecases/seed_places_usecase.dart';
import 'features/places/domain/usecases/get_random_places_usecase.dart';
import 'features/places/presentation/provider/places_provider.dart';
import 'features/places/domain/usecases/toggle_bookmark_usecase.dart';
import 'features/places/domain/usecases/get_bookmarked_place_ids_usecase.dart';

// ... (existing imports, but I am replacing the PLACES imports section and the Provider section)

// I will do two separate replaces to be safe and clean. First import.

import 'features/weather/presentation/provider/weather_provider.dart';

// ==================== Route Page ======================
import 'injection_container.dart' as di;
import 'features/route/presentation/provider/route_provider.dart';
import 'features/route/domain/usecases/get_route_use_case.dart';

//===================Currency=====================
import 'features/currency/data/datasource/currency_remote_datasource.dart';
import 'features/currency/data/repositoryIMP/currency_repository_impl.dart';
import 'features/currency/domain/repository/currency_repository.dart';
import 'features/currency/domain/usecases/currency_use_cases.dart';
import 'features/currency/presentation/provider/currency_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  // Initialize SharedPreferences for Currency feature
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ================= AUTH =================
        Provider<AuthRemoteDataSource>(create: (_) => AuthRemoteDataSource()),
        ProxyProvider<AuthRemoteDataSource, AuthRepository>(
          update: (_, dataSource, __) => AuthRepositoryImpl(remote: dataSource),
        ),
        ProxyProvider<AuthRepository, SignUpUseCase>(
          update: (_, repo, __) => SignUpUseCase(repo),
        ),
        ProxyProvider<AuthRepository, SignInUseCase>(
          update: (_, repo, __) => SignInUseCase(repo),
        ),
        ProxyProvider<AuthRepository, SignOutUseCase>(
          update: (_, repo, __) => SignOutUseCase(repo),
        ),
        ProxyProvider<AuthRepository, ResetPasswordUseCase>(
          update: (_, repo, __) => ResetPasswordUseCase(repo),
        ),
        ProxyProvider<AuthRepository, GetCurrentUserUseCase>(
          update: (_, repo, __) => GetCurrentUserUseCase(repo),
        ),
        ProxyProvider<AuthRepository, SendEmailVerificationUseCase>(
          update: (_, repo, __) => SendEmailVerificationUseCase(repo),
        ),
        ProxyProvider<AuthRepository, IsEmailVerifiedUseCase>(
          update: (_, repo, __) => IsEmailVerifiedUseCase(repo),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(
            signUpUseCase: context.read<SignUpUseCase>(),
            signInUseCase: context.read<SignInUseCase>(),
            resetPasswordUseCase: context.read<ResetPasswordUseCase>(),
            signOutUseCase: context.read<SignOutUseCase>(),
            getCurrentUserUseCase: context.read<GetCurrentUserUseCase>(),
            sendEmailVerificationUseCase: context
                .read<SendEmailVerificationUseCase>(),
            isEmailVerifiedUseCase: context.read<IsEmailVerifiedUseCase>(),
          ),
        ),

        // ================= PLACES =================
        Provider<PlacesRemoteDataSource>(
          create: (_) => PlacesRemoteDataSource(
            FirebaseFirestore.instance,
            FirebaseAuth.instance,
          ),
        ),
        ProxyProvider<PlacesRemoteDataSource, PlacesRepository>(
          update: (_, dataSource, __) => PlacesRepositoryImpl(dataSource),
        ),
        ProxyProvider<PlacesRepository, GetPlacesUseCase>(
          update: (_, repo, __) => GetPlacesUseCase(repo),
        ),
        ProxyProvider<PlacesRepository, SeedPlacesUseCase>(
          update: (_, repo, __) => SeedPlacesUseCase(repo),
        ),
        ProxyProvider<PlacesRepository, GetRandomPlacesUseCase>(
          update: (_, repo, __) => GetRandomPlacesUseCase(repo),
        ),
        ProxyProvider<PlacesRepository, ToggleBookmarkUseCase>(
          update: (_, repo, __) => ToggleBookmarkUseCase(repo),
        ),
        ProxyProvider<PlacesRepository, GetBookmarkedPlaceIdsUseCase>(
          update: (_, repo, __) => GetBookmarkedPlaceIdsUseCase(repo),
        ),
        ChangeNotifierProxyProvider5<
          GetPlacesUseCase,
          SeedPlacesUseCase,
          GetRandomPlacesUseCase,
          ToggleBookmarkUseCase,
          GetBookmarkedPlaceIdsUseCase,
          PlacesProvider
        >(
          create: (context) => PlacesProvider(
            getPlacesUseCase: context.read<GetPlacesUseCase>(),
            seedPlacesUseCase: context.read<SeedPlacesUseCase>(),
            getRandomPlacesUseCase: context.read<GetRandomPlacesUseCase>(),
            toggleBookmarkUseCase: context.read<ToggleBookmarkUseCase>(),
            getBookmarkedPlaceIdsUseCase: context
                .read<GetBookmarkedPlaceIdsUseCase>(),
          ),
          update:
              (
                context,
                getUseCase,
                seedUseCase,
                randomUseCase,
                toggleUseCase,
                getIdsUseCase,
                previous,
              ) =>
                  previous ??
                  PlacesProvider(
                    getPlacesUseCase: getUseCase,
                    seedPlacesUseCase: seedUseCase,
                    getRandomPlacesUseCase: randomUseCase,
                    toggleBookmarkUseCase: toggleUseCase,
                    getBookmarkedPlaceIdsUseCase: getIdsUseCase,
                  ),
        ),

        // ================= ITINERARY =================
        Provider<ItineraryRemoteDataSource>(
          create: (_) => ItineraryRemoteDataSource(),
        ),
        ProxyProvider<ItineraryRemoteDataSource, ItineraryRepository>(
          update: (_, dataSource, __) =>
              ItineraryRepositoryImpl(remoteDataSource: dataSource),
        ),
        ProxyProvider<ItineraryRepository, AddScheduleUseCase>(
          update: (_, repo, __) => AddScheduleUseCase(repository: repo),
        ),
        ProxyProvider<ItineraryRepository, GetSchedulesUseCase>(
          update: (_, repo, __) => GetSchedulesUseCase(repository: repo),
        ),
        ProxyProvider<ItineraryRepository, GetSchedulesByDateUseCase>(
          update: (_, repo, __) => GetSchedulesByDateUseCase(repository: repo),
        ),
        ProxyProvider<ItineraryRepository, UpdateScheduleUseCase>(
          update: (_, repo, __) => UpdateScheduleUseCase(repository: repo),
        ),
        ProxyProvider<ItineraryRepository, DeleteScheduleUseCase>(
          update: (_, repo, __) => DeleteScheduleUseCase(repository: repo),
        ),
        ChangeNotifierProxyProvider5<
          AddScheduleUseCase,
          GetSchedulesUseCase,
          GetSchedulesByDateUseCase,
          UpdateScheduleUseCase,
          DeleteScheduleUseCase,
          ItineraryProvider
        >(
          create: (context) => ItineraryProvider(
            addScheduleUseCase: context.read<AddScheduleUseCase>(),
            getSchedulesUseCase: context.read<GetSchedulesUseCase>(),
            getSchedulesByDateUseCase: context
                .read<GetSchedulesByDateUseCase>(),
            updateScheduleUseCase: context.read<UpdateScheduleUseCase>(),
            deleteScheduleUseCase: context.read<DeleteScheduleUseCase>(),
          ),
          update:
              (
                context,
                addUseCase,
                getUseCase,
                getByDateUseCase,
                updateUseCase,
                deleteUseCase,
                previous,
              ) =>
                  previous ??
                  ItineraryProvider(
                    addScheduleUseCase: addUseCase,
                    getSchedulesUseCase: getUseCase,
                    getSchedulesByDateUseCase: getByDateUseCase,
                    updateScheduleUseCase: updateUseCase,
                    deleteScheduleUseCase: deleteUseCase,
                  ),
        ),

        // ================= PROFILE =================
        Provider<ProfileRemoteDataSource>(
          create: (_) =>
              ProfileRemoteDataSourceImpl(FirebaseFirestore.instance),
        ),
        ProxyProvider<ProfileRemoteDataSource, ProfileRepository>(
          update: (_, dataSource, __) => ProfileRepositoryImpl(dataSource),
        ),
        ProxyProvider<ProfileRepository, GetProfileUseCase>(
          update: (_, repo, __) => GetProfileUseCase(repo),
        ),
        ProxyProvider<ProfileRepository, UpdateProfileUseCase>(
          update: (_, repo, __) => UpdateProfileUseCase(repo),
        ),
        ChangeNotifierProxyProvider2<
          GetProfileUseCase,
          UpdateProfileUseCase,
          ProfileProvider
        >(
          create: (context) => ProfileProvider(
            getProfileUseCase: context.read<GetProfileUseCase>(),
            updateProfileUseCase: context.read<UpdateProfileUseCase>(),
          ),
          update: (context, getProfile, updateProfile, previous) =>
              previous ??
              ProfileProvider(
                getProfileUseCase: getProfile,
                updateProfileUseCase: updateProfile,
              ),
        ),

        // ================= BUDGET =================
        Provider<BudgetRemoteDataSource>(
          create: (_) => BudgetRemoteDataSource(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
          ),
        ),
        ProxyProvider<BudgetRemoteDataSource, BudgetRepository>(
          update: (_, dataSource, __) =>
              BudgetRepositoryImpl(remoteDataSource: dataSource),
        ),
        ProxyProvider<BudgetRepository, AddTransactionUseCase>(
          update: (_, repo, __) => AddTransactionUseCase(repo),
        ),
        ProxyProvider<BudgetRepository, GetMonthlyBudgetUseCase>(
          update: (_, repo, __) => GetMonthlyBudgetUseCase(repo),
        ),
        ProxyProvider<BudgetRepository, UpdateMonthlyBudgetUseCase>(
          update: (_, repo, __) => UpdateMonthlyBudgetUseCase(repo),
        ),
        ProxyProvider<BudgetRepository, GetTransactionsUseCase>(
          update: (_, repo, __) => GetTransactionsUseCase(repo),
        ),
        ProxyProvider<BudgetRepository, GetBudgetRecommendationsUseCase>(
          update: (_, repo, __) => GetBudgetRecommendationsUseCase(repo),
        ),
        ChangeNotifierProxyProvider5<
          GetMonthlyBudgetUseCase,
          UpdateMonthlyBudgetUseCase,
          AddTransactionUseCase,
          GetTransactionsUseCase,
          GetBudgetRecommendationsUseCase,
          BudgetProvider
        >(
          create: (context) => BudgetProvider(
            getMonthlyBudgetUseCase: context.read<GetMonthlyBudgetUseCase>(),
            updateMonthlyBudgetUseCase: context
                .read<UpdateMonthlyBudgetUseCase>(),
            addTransactionUseCase: context.read<AddTransactionUseCase>(),
            getTransactionsUseCase: context.read<GetTransactionsUseCase>(),
            getBudgetRecommendationsUseCase: context
                .read<GetBudgetRecommendationsUseCase>(),
          ),
          update:
              (
                context,
                getMonthly,
                updateMonthly,
                addTrans,
                getTrans,
                getRecs,
                previous,
              ) =>
                  previous ??
                  BudgetProvider(
                    getMonthlyBudgetUseCase: getMonthly,
                    updateMonthlyBudgetUseCase: updateMonthly,
                    addTransactionUseCase: addTrans,
                    getTransactionsUseCase: getTrans,
                    getBudgetRecommendationsUseCase: getRecs,
                  ),
        ),

        // ================= CHECKLIST =================
        Provider<ChecklistRemoteDataSource>(
          create: (_) => ChecklistRemoteDataSourceImpl(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        ProxyProvider<ChecklistRemoteDataSource, ChecklistRepository>(
          update: (_, dataSource, __) =>
              ChecklistRepositoryImpl(remoteDataSource: dataSource),
        ),
        ProxyProvider<ChecklistRepository, GetChecklistUseCase>(
          update: (_, repo, __) => GetChecklistUseCase(repo),
        ),
        ProxyProvider<ChecklistRepository, AddOrUpdateChecklistItemUseCase>(
          update: (_, repo, __) => AddOrUpdateChecklistItemUseCase(repo),
        ),
        ProxyProvider<ChecklistRepository, DeleteChecklistItemUseCase>(
          update: (_, repo, __) => DeleteChecklistItemUseCase(repo),
        ),
        ChangeNotifierProxyProvider3<
          GetChecklistUseCase,
          AddOrUpdateChecklistItemUseCase,
          DeleteChecklistItemUseCase,
          ChecklistProvider
        >(
          create: (context) => ChecklistProvider(
            getChecklistUseCase: context.read<GetChecklistUseCase>(),
            addOrUpdateChecklistItemUseCase: context
                .read<AddOrUpdateChecklistItemUseCase>(),
            deleteChecklistItemUseCase: context
                .read<DeleteChecklistItemUseCase>(),
          ),
          update: (context, getUseCase, addUseCase, deleteUseCase, previous) =>
              previous ??
              ChecklistProvider(
                getChecklistUseCase: getUseCase,
                addOrUpdateChecklistItemUseCase: addUseCase,
                deleteChecklistItemUseCase: deleteUseCase,
              ),
        ),

        // ================= TRANSLATOR =================
        Provider<http.Client>(create: (_) => http.Client()),
        ProxyProvider<http.Client, TranslationRemoteDataSource>(
          update: (_, client, __) =>
              TranslationRemoteDataSourceImpl(client: client),
        ),
        ProxyProvider<TranslationRemoteDataSource, TranslationRepository>(
          update: (_, dataSource, __) =>
              TranslationRepositoryImpl(remoteDataSource: dataSource),
        ),
        ProxyProvider<TranslationRepository, TranslateText>(
          update: (_, repo, __) => TranslateText(repo),
        ),
        ChangeNotifierProxyProvider2<
          TranslateText,
          TranslationRepository,
          TranslatorProvider
        >(
          create: (context) => TranslatorProvider(
            translateTextUseCase: context.read<TranslateText>(),
            repository: context.read<TranslationRepository>(),
          ),
          update: (context, translateUseCase, repository, previous) =>
              previous ??
              TranslatorProvider(
                translateTextUseCase: translateUseCase,
                repository: repository,
              ),
        ),

        //=========Route========
        ChangeNotifierProxyProvider<GetRouteUseCase, RouteProvider>(
          create: (context) => RouteProvider(context.read<GetRouteUseCase>()),
          update: (context, getRouteUseCase, previous) =>
              previous ?? RouteProvider(getRouteUseCase),
        ),

        // ================= CURRENCY =================
        // First provide the dependencies
        Provider<Dio>(create: (_) => Dio()),
        Provider<SharedPreferences>.value(value: sharedPreferences),

        // Then create the data source with dependencies
        ProxyProvider2<Dio, SharedPreferences, CurrencyRemoteDataSource>(
          update: (_, dio, prefs, __) =>
              CurrencyRemoteDataSource(dio: dio, prefs: prefs),
        ),

        // Repository
        ProxyProvider<CurrencyRemoteDataSource, CurrencyRepository>(
          update: (_, dataSource, __) => CurrencyRepositoryImpl(dataSource),
        ),

        // Use Cases
        ProxyProvider<CurrencyRepository, GetAllCurrenciesUseCase>(
          update: (_, repo, __) => GetAllCurrenciesUseCase(repo),
        ),
        ProxyProvider<CurrencyRepository, GetExchangeRateUseCase>(
          update: (_, repo, __) => GetExchangeRateUseCase(repo),
        ),
        ProxyProvider<CurrencyRepository, ConvertCurrencyUseCase>(
          update: (_, repo, __) => ConvertCurrencyUseCase(repo),
        ),
        ProxyProvider<CurrencyRepository, GetLatestRatesUseCase>(
          update: (_, repo, __) => GetLatestRatesUseCase(repo),
        ),
        ProxyProvider<CurrencyRepository, GetPopularCurrenciesUseCase>(
          update: (_, repo, __) => GetPopularCurrenciesUseCase(repo),
        ),
        ProxyProvider<CurrencyRepository, GetUserCurrencyPreferencesUseCase>(
          update: (_, repo, __) => GetUserCurrencyPreferencesUseCase(repo),
        ),
        ProxyProvider<CurrencyRepository, UpdateUserCurrencyPreferencesUseCase>(
          update: (_, repo, __) => UpdateUserCurrencyPreferencesUseCase(repo),
        ),

        // Provider - Using ChangeNotifierProvider with manual dependency reading
        ChangeNotifierProvider(
          create: (context) => CurrencyProvider(
            getAllCurrenciesUseCase: context.read<GetAllCurrenciesUseCase>(),
            getExchangeRateUseCase: context.read<GetExchangeRateUseCase>(),
            convertCurrencyUseCase: context.read<ConvertCurrencyUseCase>(),
            getLatestRatesUseCase: context.read<GetLatestRatesUseCase>(),
            getPopularCurrenciesUseCase: context
                .read<GetPopularCurrenciesUseCase>(),
            getUserCurrencyPreferencesUseCase: context
                .read<GetUserCurrencyPreferencesUseCase>(),
            updateUserCurrencyPreferencesUseCase: context
                .read<UpdateUserCurrencyPreferencesUseCase>(),
          )..initialize(),
        ),
        //=========weather======
        ChangeNotifierProvider(create: (_) => di.getIt<WeatherNotifier>()),

        // ================= CHATBOT =================
        ChangeNotifierProvider(create: (_) => di.getIt<ChatbotProvider>()),

        // ================= LOCALE =================
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(sharedPreferences),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('fr'), // French
              Locale('ko'), // Korean
            ],
            locale: localeProvider.locale,
            debugShowCheckedModeBanner: false,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
