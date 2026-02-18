import 'package:livestock/features/sales_order/data/api/sales_order_api.dart';

import '../model/calculate_forecast_model.dart';

class SalesOrderRepository {
  final SalesOrderApi api;

  SalesOrderRepository(this.api);

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
