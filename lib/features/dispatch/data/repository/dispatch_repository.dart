import '../api/dispatch_api.dart';
import '../model/calculate_forecast_model.dart';

class DispatchRepository {
  final DispatchApi api;

  DispatchRepository(this.api);

  Future<CalculateForecast> calculateForecast({
    required int animalGroupId,
    required String forecastDate,
  }) async {
    final res = await api.calculateForecast(
      animalGroupId: animalGroupId,
      forecastDate: forecastDate,
    );

    return res.data;
  }
}
