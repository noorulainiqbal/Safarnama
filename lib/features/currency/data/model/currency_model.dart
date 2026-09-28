import '../../domain/entities/currency_entity.dart';

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({
    required super.code,
    required super.name,
    required super.symbol,
    required super.flagEmoji,
    super.country,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'] ?? '',
      flagEmoji: _getFlagEmoji(json['code']),
      country: json['country'],
    );
  }

  static String _getFlagEmoji(String currencyCode) {
    // Map currency codes to flag emojis
    final Map<String, String> currencyToFlag = {
      'USD': '🇺🇸', // US Dollar
      'EUR': '🇪🇺', // Euro
      'GBP': '🇬🇧', // British Pound
      'JPY': '🇯🇵', // Japanese Yen
      'CNY': '🇨🇳', // Chinese Yuan
      'AUD': '🇦🇺', // Australian Dollar
      'CAD': '🇨🇦', // Canadian Dollar
      'CHF': '🇨🇭', // Swiss Franc
      'HKD': '🇭🇰', // Hong Kong Dollar
      'SGD': '🇸🇬', // Singapore Dollar
      'KRW': '🇰🇷', // South Korean Won
      'INR': '🇮🇳', // Indian Rupee
      'BRL': '🇧🇷', // Brazilian Real
      'RUB': '🇷🇺', // Russian Ruble
      'ZAR': '🇿🇦', // South African Rand
      'MXN': '🇲🇽', // Mexican Peso
      'TRY': '🇹🇷', // Turkish Lira
      'AED': '🇦🇪', // UAE Dirham
      'SAR': '🇸🇦', // Saudi Riyal
      'THB': '🇹🇭', // Thai Baht
      'IDR': '🇮🇩', // Indonesian Rupiah
      'MYR': '🇲🇾', // Malaysian Ringgit
      'PHP': '🇵🇭', // Philippine Peso
      'VND': '🇻🇳', // Vietnamese Dong
      'BDT': '🇧🇩', // Bangladeshi Taka
      'PKR': '🇵🇰', // Pakistani Rupee
      'LKR': '🇱🇰', // Sri Lankan Rupee
      'NPR': '🇳🇵', // Nepalese Rupee
      'MMK': '🇲🇲', // Myanmar Kyat
    };

    return currencyToFlag[currencyCode] ?? '🏳️';
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'flagEmoji': flagEmoji,
      'country': country,
    };
  }
}
