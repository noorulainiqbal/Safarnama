class CurrencyEntity {
  final String code;
  final String name;
  final String symbol;
  final String flagEmoji;
  final String? country;

  CurrencyEntity({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flagEmoji,
    this.country,
  });
}
