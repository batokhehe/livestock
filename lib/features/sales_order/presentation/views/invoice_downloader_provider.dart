import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../sales_order_provider.dart';

final invoiceDownloadProgressProvider = StateProvider.family<double, int>(
  (ref, id) => 0.0,
);

final invoiceDownloaderProvider = Provider((ref) => InvoiceDownloader(ref));

class InvoiceDownloader {
  final Ref ref;
  InvoiceDownloader(this.ref);

  Future<String?> downloadInvoice(int id, String fileName) async {
    try {
      final api = ref.read(salesOrderApiProvider);

      final tempDir = await getTemporaryDirectory();
      final savePath = "${tempDir.path}/$id-$fileName";

      await api
          .downloadSalesInvoice(
            id,
            onProgress: (received, total) {
              if (total != -1) {
                final progress = received / total;
                ref.read(invoiceDownloadProgressProvider(id).notifier).state =
                    progress;
              }
            },
          )
          .then((response) async {
            final File file = File(savePath);
            await file.writeAsBytes(response.data);
          });

      ref.read(invoiceDownloadProgressProvider(id).notifier).state = 0.0;

      return savePath;
    } catch (e) {
      ref.read(invoiceDownloadProgressProvider(id).notifier).state = 0.0;
      rethrow;
    }
  }
}
