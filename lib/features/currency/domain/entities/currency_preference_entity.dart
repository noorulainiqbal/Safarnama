class CurrencyPreferenceEntity {
  final String userId;
  final String homeCurrency;
  final List<String> favoriteCurrencies;
  final DateTime lastUpdated;

  CurrencyPreferenceEntity({
    required this.userId,
    required this.homeCurrency,
    required this.favoriteCurrencies,
    required this.lastUpdated,
  });
}
