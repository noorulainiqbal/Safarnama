class ExchangeRateEntity {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final double? change;
  final double? changePercentage;
  final DateTime lastUpdated;

  ExchangeRateEntity({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    this.change,
    this.changePercentage,
    required this.lastUpdated,
  });

  String get pair => '$baseCurrency/$targetCurrency';
}
