class ConversionResultEntity {
  final String fromCurrency;
  final String toCurrency;
  final double fromAmount;
  final double toAmount;
  final double rate;
  final DateTime conversionTime;
  final double? fee;

  ConversionResultEntity({
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.rate,
    required this.conversionTime,
    this.fee,
  });

  // Fixed: Fee is already deducted or should be shown separately
  // Return the converted amount as-is
  double get totalAmount => toAmount;

  // If you want to show amount after fee deduction, use this getter
  double get amountAfterFee => fee != null ? toAmount - fee! : toAmount;
}
