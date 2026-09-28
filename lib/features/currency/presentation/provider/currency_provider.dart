// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasource/currency_remote_datasource.dart';
import '../../domain/entities/currency_entity.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/entities/conversion_result_entity.dart';
import '../../domain/entities/currency_preference_entity.dart';
import '../../domain/usecases/currency_use_cases.dart';

class CurrencyProvider extends ChangeNotifier {
  // Use Cases
  final GetAllCurrenciesUseCase getAllCurrenciesUseCase;
  final GetExchangeRateUseCase getExchangeRateUseCase;
  final ConvertCurrencyUseCase convertCurrencyUseCase;
  final GetLatestRatesUseCase getLatestRatesUseCase;
  final GetPopularCurrenciesUseCase getPopularCurrenciesUseCase;
  final GetUserCurrencyPreferencesUseCase getUserCurrencyPreferencesUseCase;
  final UpdateUserCurrencyPreferencesUseCase
  updateUserCurrencyPreferencesUseCase;

  CurrencyProvider({
    required this.getAllCurrenciesUseCase,
    required this.getExchangeRateUseCase,
    required this.convertCurrencyUseCase,
    required this.getLatestRatesUseCase,
    required this.getPopularCurrenciesUseCase,
    required this.getUserCurrencyPreferencesUseCase,
    required this.updateUserCurrencyPreferencesUseCase,
  });

  // State
  List<CurrencyEntity> _allCurrencies = [];
  List<CurrencyEntity> get allCurrencies => _allCurrencies;

  List<CurrencyEntity> _popularCurrencies = [];
  List<CurrencyEntity> get popularCurrencies => _popularCurrencies;

  CurrencyEntity? _fromCurrency;
  CurrencyEntity? get fromCurrency => _fromCurrency;

  CurrencyEntity? _toCurrency;
  CurrencyEntity? get toCurrency => _toCurrency;

  double _fromAmount = 1.0;
  double get fromAmount => _fromAmount;

  ConversionResultEntity? _conversionResult;
  ConversionResultEntity? get conversionResult => _conversionResult;

  ExchangeRateEntity? _exchangeRate;
  ExchangeRateEntity? get exchangeRate => _exchangeRate;

  Map<String, double> _latestRates = {};
  Map<String, double> get latestRates => _latestRates;

  CurrencyPreferenceEntity? _userPreferences;
  CurrencyPreferenceEntity? get userPreferences => _userPreferences;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isConverting = false;
  bool get isConverting => _isConverting;

  String? _error;
  String? get error => _error;

  // Initialize
  Future<void> initialize() async {
    await _loadCurrencies();
    await _loadUserPreferences();
  }

  // Load all currencies
  Future<void> _loadCurrencies() async {
    _isLoading = true;
    notifyListeners();

    final result = await getAllCurrenciesUseCase.execute();

    result.fold(
      (failure) {
        _error = failure;
      },
      (currencies) {
        _allCurrencies = currencies;
        _setDefaultCurrencies();
      },
    );

    // Load popular currencies
    final popularResult = await getPopularCurrenciesUseCase.execute();
    popularResult.fold(
      (failure) => null,
      (currencies) => _popularCurrencies = currencies,
    );

    // Load latest rates
    await _loadLatestRates();

    _isLoading = false;
    notifyListeners();
  }

  // Load user preferences
  Future<void> _loadUserPreferences() async {
    // In a real app, you would get userId from auth
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 'default_user';

    final result = await getUserCurrencyPreferencesUseCase.execute(userId);

    result.fold((failure) => null, (preferences) {
      _userPreferences = preferences;
      // Set home currency as from currency if not set
      if (_fromCurrency == null) {
        final homeCurrency = _allCurrencies.firstWhere(
          (c) => c.code == preferences.homeCurrency,
          orElse: () => _allCurrencies.first,
        );
        _fromCurrency = homeCurrency;
      }
    });
  }

  // Load latest exchange rates
  Future<void> _loadLatestRates() async {
    if (_fromCurrency != null) {
      final result = await getLatestRatesUseCase.execute(
        baseCurrency: _fromCurrency!.code,
      );

      result.fold((failure) => null, (rates) {
        _latestRates = rates;
        // Update exchange rate if toCurrency is set
        if (_toCurrency != null) {
          _updateExchangeRate();
        }
      });
    }
  }

  // Set default currencies
  void _setDefaultCurrencies() {
    if (_allCurrencies.isNotEmpty) {
      _fromCurrency ??= _allCurrencies.firstWhere(
        (c) => c.code == 'USD',
        orElse: () => _allCurrencies.first,
      );

      _toCurrency ??= _allCurrencies.firstWhere(
        (c) => c.code == 'EUR',
        orElse: () => _allCurrencies.elementAt(1),
      );
    }
  }

  // Update exchange rate
  Future<void> _updateExchangeRate() async {
    if (_fromCurrency != null && _toCurrency != null) {
      final result = await getExchangeRateUseCase.execute(
        fromCurrency: _fromCurrency!.code,
        toCurrency: _toCurrency!.code,
      );

      result.fold(
        (failure) => _error = failure,
        (rate) => _exchangeRate = rate,
      );

      notifyListeners();
    }
  }

  // Set from currency
  Future<void> setFromCurrency(CurrencyEntity currency) async {
    _fromCurrency = currency;
    await _loadLatestRates();
    await _performConversion();
    notifyListeners();
  }

  // Set to currency
  Future<void> setToCurrency(CurrencyEntity currency) async {
    _toCurrency = currency;
    await _updateExchangeRate();
    await _performConversion();
    notifyListeners();
  }

  // Swap currencies
  Future<void> swapCurrencies() async {
    final temp = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = temp;

    await _loadLatestRates();
    await _performConversion();
    notifyListeners();
  }

  // Update from amount
  void updateFromAmount(String amount) {
    final cleanAmount = amount.replaceAll(',', '');
    final value = double.tryParse(cleanAmount) ?? 0.0;
    _fromAmount = value;
    _performConversion();
    notifyListeners();
  }

  // Perform conversion
  Future<void> _performConversion() async {
    if (_fromCurrency != null && _toCurrency != null && _fromAmount > 0) {
      _isConverting = true;
      notifyListeners();

      final result = await convertCurrencyUseCase.execute(
        fromCurrency: _fromCurrency!.code,
        toCurrency: _toCurrency!.code,
        amount: _fromAmount,
      );

      _isConverting = false;

      result.fold(
        (failure) => _error = failure,
        (result) => _conversionResult = result,
      );

      notifyListeners();
    }
  }

  // Format amount with commas

  // Get conversion rate for display
  String getConversionRate() {
    if (_exchangeRate != null) {
      return '1 ${_fromCurrency?.code} = ${_exchangeRate!.rate.toStringAsFixed(4)} ${_toCurrency?.code}';
    }
    return '';
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Update user preferences
  Future<void> updateUserPreferences({
    required String homeCurrency,
    required List<String> favoriteCurrencies,
  }) async {
    if (_userPreferences != null) {
      final updated = _userPreferences!.copyWith(
        homeCurrency: homeCurrency,
        favoriteCurrencies: favoriteCurrencies,
      );

      final result = await updateUserCurrencyPreferencesUseCase.execute(
        updated,
      );

      result.fold(
        (failure) => _error = failure,
        (preferences) => _userPreferences = preferences,
      );

      notifyListeners();
    }
  }

  // Get converted amount - FIXED
  String getConvertedAmount() {
    if (_conversionResult != null) {
      // Use toAmount directly, not totalAmount
      return formatAmount(_conversionResult!.toAmount);
    }
    return '0.00';
  }

  // Format amount with commas - Already correct
  String formatAmount(double amount) {
    // Handle negative amounts (shouldn't happen, but just in case)
    if (amount < 0) {
      print('Warning: Negative amount detected: $amount');
      amount = amount.abs();
    }

    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}
