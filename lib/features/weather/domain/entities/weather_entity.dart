class WeatherEntity {
  final String description;
  final String iconCode;
  final double temperature;
  final String cityName;

  WeatherEntity({
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.cityName,
  });

  String get comprehensiveDescription {
    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('clear')) {
      return "Currently, the sun is shining bright.";
    } else if (lowerDesc.contains('few clouds')) {
      return "Currently, a few clouds are visible.";
    } else if (lowerDesc.contains('clouds')) {
      return "Currently, it is a bit cloudy.";
    } else if (lowerDesc.contains('rain')) {
      return "Currently, it is raining outside, fetch an umbrella!.";
    } else if (lowerDesc.contains('snow')) {
      return "Currently, it's snowing outside today!.";
    } else if (lowerDesc.contains('thunderstorm')) {
      return "Currently, there is a thunderstorm.";
    } else if (lowerDesc.contains('drizzle')) {
      return "Currently, it is lightly drizzling.";
    } else if (lowerDesc.contains('mist') || lowerDesc.contains('fog')) {
      return "Currently, it is misty and foggy.";
    } else if (lowerDesc.contains('haze')) {
      return "Currently, the weather is hazy.";
    } else if (lowerDesc.contains('smoke')) {
      return "Currently, the weather is smoky.";
    } else {
      return "Currently, the weather is $description.";
    }
  }
}
