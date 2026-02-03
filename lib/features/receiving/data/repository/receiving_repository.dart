import '../api/receiving_api.dart';
import '../model/receiving_list_model.dart';

class ReceivingRepository {
  final ReceivingApi api;

  ReceivingRepository(this.api);

  Future<List<ReceivingList>> getReceiving({required String receiveType}) async {
    return api.getReceiving(receiveType: receiveType);
  }
}
