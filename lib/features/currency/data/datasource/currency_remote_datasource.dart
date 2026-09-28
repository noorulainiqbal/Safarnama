// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/currency_entity.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/entities/conversion_result_entity.dart';
import '../../domain/entities/currency_preference_entity.dart';
import '../model/currency_model.dart';
import '../model/exchange_rate_model.dart';

class CurrencyRemoteDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  static const String _cacheKey = 'currency_cache';
  static const String _cacheTimestampKey = 'currency_cache_timestamp';
  static const Duration _cacheDuration = Duration(minutes: 30);

  CurrencyRemoteDataSource({required this.dio, required this.prefs});

  // Get all currencies with rates from API
  Future<Map<String, double>> getLatestRates({
    String baseCurrency = 'USD',
  }) async {
    try {
      // Check cache first
      final cachedData = await _getCachedRates(baseCurrency);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API
      final response = await dio.get('$_baseUrl/$baseCurrency');

      if (response.statusCode == 200) {
        final data = response.data;
        final ratesData = data['rates'] as Map<String, dynamic>;

        // Convert all values to double, handling both int and double
        final rates = <String, double>{};
        ratesData.forEach((key, value) {
          rates[key] = (value as num).toDouble();
        });

        // Cache the results
        await _cacheRates(baseCurrency, rates, DateTime.now());

        return rates;
      } else {
        throw Exception(
          'Failed to fetch exchange rates: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching rates: $e');
      // Try to return cached data even if expired
      final cachedData = await _getCachedRates(
        baseCurrency,
        ignoreExpiry: true,
      );
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch exchange rates: $e');
    }
  }

  // Cache Management
  Future<void> _cacheRates(
    String baseCurrency,
    Map<String, double> rates,
    DateTime timestamp,
  ) async {
    try {
      final cacheData = {
        'baseCurrency': baseCurrency,
        'rates': rates,
        'timestamp': timestamp.toIso8601String(),
      };

      await prefs.setString(
        '${_cacheKey}_$baseCurrency',
        json.encode(cacheData),
      );
      await prefs.setString(
        '${_cacheTimestampKey}_$baseCurrency',
        timestamp.toIso8601String(),
      );
    } catch (e) {
      print('Error caching rates: $e');
    }
  }

  Future<Map<String, double>?> _getCachedRates(
    String baseCurrency, {
    bool ignoreExpiry = false,
  }) async {
    try {
      final cacheData = prefs.getString('${_cacheKey}_$baseCurrency');
      final timestampStr = prefs.getString(
        '${_cacheTimestampKey}_$baseCurrency',
      );

      if (cacheData != null && timestampStr != null) {
        final timestamp = DateTime.parse(timestampStr);
        final now = DateTime.now();

        if (ignoreExpiry || now.difference(timestamp) < _cacheDuration) {
          final decoded = json.decode(cacheData);
          final ratesData = decoded['rates'] as Map<String, dynamic>;

          // Convert all cached values to double
          final rates = <String, double>{};
          ratesData.forEach((key, value) {
            rates[key] = (value as num).toDouble();
          });

          return rates;
        }
      }
    } catch (e) {
      print('Error reading cache: $e');
    }
    return null;
  }

  // Currency Information
  Future<List<CurrencyEntity>> getAllCurrencies() async {
    // Hardcoded list of major currencies
    return [
      CurrencyModel(
        code: 'USD',
        name: 'US Dollar',
        symbol: '\$',
        flagEmoji: '🇺🇸',
      ),
      CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flagEmoji: '🇪🇺'),
      CurrencyModel(
        code: 'GBP',
        name: 'British Pound',
        symbol: '£',
        flagEmoji: '🇬🇧',
      ),
      CurrencyModel(
        code: 'JPY',
        name: 'Japanese Yen',
        symbol: '¥',
        flagEmoji: '🇯🇵',
      ),
      CurrencyModel(
        code: 'CNY',
        name: 'Chinese Yuan',
        symbol: '¥',
        flagEmoji: '🇨🇳',
      ),
      CurrencyModel(
        code: 'AUD',
        name: 'Australian Dollar',
        symbol: 'A\$',
        flagEmoji: '🇦🇺',
      ),
      CurrencyModel(
        code: 'CAD',
        name: 'Canadian Dollar',
        symbol: 'C\$',
        flagEmoji: '🇨🇦',
      ),
      CurrencyModel(
        code: 'CHF',
        name: 'Swiss Franc',
        symbol: 'CHF',
        flagEmoji: '🇨🇭',
      ),
      CurrencyModel(
        code: 'HKD',
        name: 'Hong Kong Dollar',
        symbol: 'HK\$',
        flagEmoji: '🇭🇰',
      ),
      CurrencyModel(
        code: 'SGD',
        name: 'Singapore Dollar',
        symbol: 'S\$',
        flagEmoji: '🇸🇬',
      ),
      CurrencyModel(
        code: 'KRW',
        name: 'South Korean Won',
        symbol: '₩',
        flagEmoji: '🇰🇷',
      ),
      CurrencyModel(
        code: 'INR',
        name: 'Indian Rupee',
        symbol: '₹',
        flagEmoji: '🇮🇳',
      ),
      CurrencyModel(
        code: 'BRL',
        name: 'Brazilian Real',
        symbol: 'R\$',
        flagEmoji: '🇧🇷',
      ),
      CurrencyModel(
        code: 'RUB',
        name: 'Russian Ruble',
        symbol: '₽',
        flagEmoji: '🇷🇺',
      ),
      CurrencyModel(
        code: 'ZAR',
        name: 'South African Rand',
        symbol: 'R',
        flagEmoji: '🇿🇦',
      ),
      CurrencyModel(
        code: 'MXN',
        name: 'Mexican Peso',
        symbol: '\$',
        flagEmoji: '🇲🇽',
      ),
      CurrencyModel(
        code: 'TRY',
        name: 'Turkish Lira',
        symbol: '₺',
        flagEmoji: '🇹🇷',
      ),
      CurrencyModel(
        code: 'AED',
        name: 'UAE Dirham',
        symbol: 'د.إ',
        flagEmoji: '🇦🇪',
      ),
      CurrencyModel(
        code: 'SAR',
        name: 'Saudi Riyal',
        symbol: 'ر.س',
        flagEmoji: '🇸🇦',
      ),
      CurrencyModel(
        code: 'THB',
        name: 'Thai Baht',
        symbol: '฿',
        flagEmoji: '🇹🇭',
      ),
      CurrencyModel(
        code: 'IDR',
        name: 'Indonesian Rupiah',
        symbol: 'Rp',
        flagEmoji: '🇮🇩',
      ),
      CurrencyModel(
        code: 'MYR',
        name: 'Malaysian Ringgit',
        symbol: 'RM',
        flagEmoji: '🇲🇾',
      ),
      CurrencyModel(
        code: 'PHP',
        name: 'Philippine Peso',
        symbol: '₱',
        flagEmoji: '🇵🇭',
      ),
      CurrencyModel(
        code: 'VND',
        name: 'Vietnamese Dong',
        symbol: '₫',
        flagEmoji: '🇻🇳',
      ),
      CurrencyModel(
        code: 'BDT',
        name: 'Bangladeshi Taka',
        symbol: '৳',
        flagEmoji: '🇧🇩',
      ),
      CurrencyModel(
        code: 'PKR',
        name: 'Pakistani Rupee',
        symbol: '₨',
        flagEmoji: '🇵🇰',
      ),
      CurrencyModel(
        code: 'LKR',
        name: 'Sri Lankan Rupee',
        symbol: 'රු',
        flagEmoji: '🇱🇰',
      ),
      CurrencyModel(
        code: 'NPR',
        name: 'Nepalese Rupee',
        symbol: 'रू',
        flagEmoji: '🇳🇵',
      ),
      CurrencyModel(
        code: 'MMK',
        name: 'Myanmar Kyat',
        symbol: 'K',
        flagEmoji: '🇲🇲',
      ),
    ];
  }

  Future<List<CurrencyEntity>> getPopularCurrencies() async {
    final allCurrencies = await getAllCurrencies();
    final popularCodes = [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'AUD',
      'CAD',
      'CHF',
      'CNY',
    ];

    return allCurrencies
        .where((currency) => popularCodes.contains(currency.code))
        .toList();
  }

  // Get exchange rate between two currencies
  Future<ExchangeRateEntity> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      // Get rates with fromCurrency as base
      final rates = await getLatestRates(baseCurrency: fromCurrency);

      if (rates.containsKey(toCurrency)) {
        final rate = rates[toCurrency]!;
        final previousRate = await _getPreviousRate(fromCurrency, toCurrency);

        double? change;
        double? changePercentage;

        if (previousRate != null) {
          change = rate - previousRate;
          changePercentage = (change / previousRate) * 100;
        }

        return ExchangeRateModel(
          baseCurrency: fromCurrency,
          targetCurrency: toCurrency,
          rate: rate,
          change: change,
          changePercentage: changePercentage,
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('Rate not available for $toCurrency');
      }
    } catch (e) {
      print('Error getting exchange rate: $e');
      throw Exception('Failed to get exchange rate: $e');
    }
  }

  Future<double?> _getPreviousRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    // This could be implemented to fetch yesterday's rate from a historical API
    // For now, return null
    return null;
  }

  // Convert currency
  Future<ConversionResultEntity> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    try {
      // Get the exchange rate
      final exchangeRate = await getExchangeRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );

      // Calculate converted amount
      final convertedAmount = amount * exchangeRate.rate;

      // Calculate fee (example: 1% with minimum $1)
      final fee = _calculateFee(amount, fromCurrency);

      return ConversionResultEntity(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        fromAmount: amount,
        toAmount: convertedAmount,
        rate: exchangeRate.rate,
        conversionTime: DateTime.now(),
        fee: fee,
      );
    } catch (e) {
      print('Error converting currency: $e');
      throw Exception('Failed to convert currency: $e');
    }
  }

  double _calculateFee(double amount, String currency) {
    // Example fee calculation: 1% with minimum equivalent of $1
    const double feePercentage = 0.01;
    final double calculatedFee = amount * feePercentage;

    // Minimum fee equivalent to $1 in the currency
    final double minFee = currency == 'USD' ? 1.0 : 1.0; // Simplified

    return calculatedFee > minFee ? calculatedFee : minFee;
  }

  // User Preferences
  Future<CurrencyPreferenceEntity> getUserCurrencyPreferences(
    String userId,
  ) async {
    try {
      final prefsKey = 'currency_preferences_$userId';
      final prefsData = prefs.getString(prefsKey);

      if (prefsData != null) {
        final decoded = json.decode(prefsData);
        return CurrencyPreferenceEntity(
          userId: decoded['userId'],
          homeCurrency: decoded['homeCurrency'] ?? 'USD',
          favoriteCurrencies: List<String>.from(
            decoded['favoriteCurrencies'] ?? [],
          ),
          lastUpdated: DateTime.parse(decoded['lastUpdated']),
        );
      }
    } catch (e) {
      print('Error getting user preferences: $e');
    }

    // Default preferences
    return CurrencyPreferenceEntity(
      userId: userId,
      homeCurrency: 'USD',
      favoriteCurrencies: ['USD', 'EUR', 'GBP', 'JPY'],
      lastUpdated: DateTime.now(),
    );
  }

  Future<CurrencyPreferenceEntity> updateUserCurrencyPreferences(
    CurrencyPreferenceEntity preferences,
  ) async {
    try {
      final prefsKey = 'currency_preferences_${preferences.userId}';

      final data = {
        'userId': preferences.userId,
        'homeCurrency': preferences.homeCurrency,
        'favoriteCurrencies': preferences.favoriteCurrencies,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await prefs.setString(prefsKey, json.encode(data));

      return preferences.copyWith(lastUpdated: DateTime.now());
    } catch (e) {
      print('Error updating user preferences: $e');
      throw Exception('Failed to update user preferences: $e');
    }
  }
}

extension CurrencyPreferenceExtension on CurrencyPreferenceEntity {
  CurrencyPreferenceEntity copyWith({
    String? homeCurrency,
    List<String>? favoriteCurrencies,
    DateTime? lastUpdated,
  }) {
    return CurrencyPreferenceEntity(
      userId: userId,
      homeCurrency: homeCurrency ?? this.homeCurrency,
      favoriteCurrencies: favoriteCurrencies ?? this.favoriteCurrencies,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
