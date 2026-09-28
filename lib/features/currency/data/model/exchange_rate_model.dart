import '../../domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  ExchangeRateModel({
    required super.baseCurrency,
    required super.targetCurrency,
    required super.rate,
    super.change,
    super.changePercentage,
    required super.lastUpdated,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCurrency: json['baseCurrency'] as String,
      targetCurrency: json['targetCurrency'] as String,
      rate: _toDouble(json['rate']),
      change: json['change'] != null ? _toDouble(json['change']) : null,
      changePercentage: json['changePercentage'] != null
          ? _toDouble(json['changePercentage'])
          : null,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  // Helper method to safely convert num to double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'rate': rate,
      'change': change,
      'changePercentage': changePercentage,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
