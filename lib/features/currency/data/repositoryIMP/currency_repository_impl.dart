import 'package:dartz/dartz.dart';
import '../../domain/entities/currency_entity.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/entities/conversion_result_entity.dart';
import '../../domain/entities/currency_preference_entity.dart';
import '../../domain/repository/currency_repository.dart';
import '../datasource/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<CurrencyEntity>>> getAllCurrencies() async {
    try {
      final currencies = await remoteDataSource.getAllCurrencies();
      return Right(currencies);
    } catch (e) {
      return Left('Failed to get currencies: $e');
    }
  }

  @override
  Future<Either<String, CurrencyEntity>> getCurrencyByCode(String code) async {
    try {
      final currencies = await remoteDataSource.getAllCurrencies();
      final currency = currencies.firstWhere(
        (c) => c.code == code,
        orElse: () => throw Exception('Currency not found: $code'),
      );
      return Right(currency);
    } catch (e) {
      return Left('Failed to get currency: $e');
    }
  }

  @override
  Future<Either<String, List<CurrencyEntity>>> getPopularCurrencies() async {
    try {
      final currencies = await remoteDataSource.getPopularCurrencies();
      return Right(currencies);
    } catch (e) {
      return Left('Failed to get popular currencies: $e');
    }
  }

  @override
  Future<Either<String, Map<String, double>>> getLatestRates({
    String baseCurrency = 'USD',
  }) async {
    try {
      final rates = await remoteDataSource.getLatestRates(
        baseCurrency: baseCurrency,
      );
      return Right(rates);
    } catch (e) {
      return Left('Failed to get latest rates: $e');
    }
  }

  @override
  Future<Either<String, ExchangeRateEntity>> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final rate = await remoteDataSource.getExchangeRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );
      return Right(rate);
    } catch (e) {
      return Left('Failed to get exchange rate: $e');
    }
  }

  @override
  Future<Either<String, ConversionResultEntity>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    try {
      final result = await remoteDataSource.convertCurrency(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        amount: amount,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to convert currency: $e');
    }
  }

  @override
  Future<Either<String, Map<String, double>>> getHistoricalRates({
    required String baseCurrency,
    required String targetCurrency,
    required DateTime date,
  }) async {
    // Implementation would need historical API endpoint
    return Left('Historical rates not implemented');
  }

  @override
  Future<Either<String, CurrencyPreferenceEntity>> getUserCurrencyPreferences(
    String userId,
  ) async {
    try {
      final preferences = await remoteDataSource.getUserCurrencyPreferences(
        userId,
      );
      return Right(preferences);
    } catch (e) {
      return Left('Failed to get user preferences: $e');
    }
  }

  @override
  Future<Either<String, CurrencyPreferenceEntity>>
  updateUserCurrencyPreferences(CurrencyPreferenceEntity preferences) async {
    try {
      final updated = await remoteDataSource.updateUserCurrencyPreferences(
        preferences,
      );
      return Right(updated);
    } catch (e) {
      return Left('Failed to update user preferences: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    // Implementation for cache clearing
  }

  @override
  Future<bool> shouldRefreshCache() {
    // Implementation for cache refresh logic
    return Future.value(true);
  }
}
