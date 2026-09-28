import 'package:dartz/dartz.dart';
import '../entities/currency_entity.dart';
import '../entities/exchange_rate_entity.dart';
import '../entities/conversion_result_entity.dart';
import '../entities/currency_preference_entity.dart';
import '../repository/currency_repository.dart';

class GetAllCurrenciesUseCase {
  final CurrencyRepository repository;

  GetAllCurrenciesUseCase(this.repository);

  Future<Either<String, List<CurrencyEntity>>> execute() {
    return repository.getAllCurrencies();
  }
}

class GetExchangeRateUseCase {
  final CurrencyRepository repository;

  GetExchangeRateUseCase(this.repository);

  Future<Either<String, ExchangeRateEntity>> execute({
    required String fromCurrency,
    required String toCurrency,
  }) {
    return repository.getExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }
}

class ConvertCurrencyUseCase {
  final CurrencyRepository repository;

  ConvertCurrencyUseCase(this.repository);

  Future<Either<String, ConversionResultEntity>> execute({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) {
    return repository.convertCurrency(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount,
    );
  }
}

class GetLatestRatesUseCase {
  final CurrencyRepository repository;

  GetLatestRatesUseCase(this.repository);

  Future<Either<String, Map<String, double>>> execute({
    String baseCurrency = 'USD',
  }) {
    return repository.getLatestRates(baseCurrency: baseCurrency);
  }
}

class GetPopularCurrenciesUseCase {
  final CurrencyRepository repository;

  GetPopularCurrenciesUseCase(this.repository);

  Future<Either<String, List<CurrencyEntity>>> execute() {
    return repository.getPopularCurrencies();
  }
}

class GetUserCurrencyPreferencesUseCase {
  final CurrencyRepository repository;

  GetUserCurrencyPreferencesUseCase(this.repository);

  Future<Either<String, CurrencyPreferenceEntity>> execute(String userId) {
    return repository.getUserCurrencyPreferences(userId);
  }
}

class UpdateUserCurrencyPreferencesUseCase {
  final CurrencyRepository repository;

  UpdateUserCurrencyPreferencesUseCase(this.repository);

  Future<Either<String, CurrencyPreferenceEntity>> execute(
    CurrencyPreferenceEntity preferences,
  ) {
    return repository.updateUserCurrencyPreferences(preferences);
  }
}
