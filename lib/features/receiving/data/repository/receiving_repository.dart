import '../api/receiving_api.dart';
import '../model/receiving_list_model.dart';

class ReceivingRepository {
  final ReceivingApi api;

  ReceivingRepository(this.api);

  Future<List<ReceivingList>> getReceiving({
    required String receiveType,
    int? farmLocationId,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final res = await api.getReceiving(
      receiveType: receiveType,
      farmLocationId: farmLocationId,
      page: page,
      perPage: perPage,
      search: search,
    );

    return res.data;
  }
}
