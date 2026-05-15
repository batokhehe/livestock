import 'package:dio/dio.dart';
import 'package:livestock/core/data/model/base_response_single.dart';

import '../model/purchase_order_list_model.dart';
import '../model/purchase_order_request_model.dart';
import '../model/purchase_invoice_model.dart';
import 'package:livestock/core/data/model/payment_type_model.dart';
import 'package:livestock/core/data/model/chart_of_account_model.dart';
import 'package:livestock/core/data/model/bank_account_model.dart';

class PurchaseOrderApi {
  final Dio dio;

  PurchaseOrderApi(this.dio);

  Future<List<PurchaseOrderList>> getPurchaseOrder({
    required String type,
    String? search,
    int? page,
    int? perPage,
  }) async {
    final res = await dio.get(
      '/transaction/purch-order',
      queryParameters: {
        'type': type,
        'search': search,
        'page': page,
        'per_page': perPage,
      }..removeWhere((k, v) => v == null || v == ''),
    );

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data['data'];

    return list.map((e) => PurchaseOrderList.fromJson(e)).toList();
  }

  Future<void> submitPurchaseOrder(PurchaseOrderRequest request) async {
    final res = await dio.post(
      "/transaction/purch-order",
      data: request.toJson(),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<void> updatePurchaseOrder(int id, PurchaseOrderRequest request) async {
    final res = await dio.put(
      "/transaction/purch-order/$id",
      data: request.toJson(),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<BaseResponseSingle<PurchaseOrderList>> getPurchaseOrderDetail(
    int id,
  ) async {
    final res = await dio.get('/transaction/purch-order/$id');
    return BaseResponseSingle.fromJson(
      res.data,
      (json) => PurchaseOrderList.fromJson(json),
    );
  }

  Future<List<PaymentType>> getPaymentTypes() async {
    final res = await dio.get('/transaction/purch-invoice/payment-types');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data is Map ? data['data'] : data;
    return list.map((e) => PaymentType.fromJson(e)).toList();
  }

  Future<List<ChartOfAccount>> getChartOfAccounts() async {
    final res = await dio.get('/transaction/purch-invoice/chart-of-accounts');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data is Map ? data['data'] : data;
    return list.map((e) => ChartOfAccount.fromJson(e)).toList();
  }

  Future<List<BankAccount>> getBankAccounts() async {
    final res = await dio.get('/transaction/purch-invoice/bank-accounts');

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data is Map ? data['data'] : data;
    return list.map((e) => BankAccount.fromJson(e)).toList();
  }

  Future<void> submitPurchaseInvoice(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    final res = await dio.post("/transaction/purch-invoice", data: formData);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<({List<PurchaseInvoice> invoices, bool hasMore})> getPurchaseInvoices(
    int poId, {
    int page = 1,
    int perPage = 5,
  }) async {
    final res = await dio.get(
      '/transaction/purch-invoice',
      queryParameters: {
        'purch_order_id': poId,
        'page': page,
        'per_page': perPage,
      },
    );

    if (res.statusCode != 200) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    final data = res.data;
    final List list = data['data'] ?? [];
    final invoices = list.map((e) => PurchaseInvoice.fromJson(e)).toList();
    final lastPage = data['last_page'] as int? ?? 1;
    final currentPage = data['current_page'] as int? ?? 1;

    return (invoices: invoices, hasMore: currentPage < lastPage);
  }

  Future<Response> downloadPurchaseInvoice(
    int invoiceId, {
    void Function(int, int)? onProgress,
  }) async {
    return await dio.get(
      '/transaction/purch-invoice/$invoiceId/print',
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
      onReceiveProgress: onProgress,
    );
  }

  Future<void> cancelPurchaseInvoice(
    int invoiceId,
    Map<String, dynamic> data,
  ) async {
    final res = await dio.put("/transaction/purch-invoice/$invoiceId", data: data);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
