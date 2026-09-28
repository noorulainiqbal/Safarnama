import 'package:dartz/dartz.dart';
import '../entities/currency_entity.dart';
import '../entities/exchange_rate_entity.dart';
import '../entities/conversion_result_entity.dart';
import '../entities/currency_preference_entity.dart';

abstract class CurrencyRepository {
  // Currency Data
  Future<Either<String, List<CurrencyEntity>>> getAllCurrencies();
  Future<Either<String, CurrencyEntity>> getCurrencyByCode(String code);
  Future<Either<String, List<CurrencyEntity>>> getPopularCurrencies();

  // Exchange Rates
  Future<Either<String, Map<String, double>>> getLatestRates({
    String baseCurrency = 'USD',
  });
  Future<Either<String, ExchangeRateEntity>> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  });

  // Conversion
  Future<Either<String, ConversionResultEntity>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });

  // Historical Data
  Future<Either<String, Map<String, double>>> getHistoricalRates({
    required String baseCurrency,
    required String targetCurrency,
    required DateTime date,
  });

  // User Preferences
  Future<Either<String, CurrencyPreferenceEntity>> getUserCurrencyPreferences(
    String userId,
  );
  Future<Either<String, CurrencyPreferenceEntity>>
  updateUserCurrencyPreferences(CurrencyPreferenceEntity preferences);

  // Cache Management
  Future<void> clearCache();
  Future<bool> shouldRefreshCache();
}
