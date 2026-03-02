class CalculateForecast {
  final double targetAdg;
  final double targetPriceForecast;
  final double forecastWeight;
  final double forecastPrice;

  CalculateForecast({
    required this.targetAdg,
    required this.targetPriceForecast,
    required this.forecastWeight,
    required this.forecastPrice,
  });

  factory CalculateForecast.fromJson(Map<String, dynamic> json) {
    return CalculateForecast(
      targetAdg: double.tryParse(json['target_adg'].toString()) ?? 0,
      targetPriceForecast:
          double.tryParse(json['target_price_forecast'].toString()) ?? 0,
      forecastWeight: double.tryParse(json['forecast_weight'].toString()) ?? 0,
      forecastPrice: double.tryParse(json['forecast_price'].toString()) ?? 0,
    );
  }
}
