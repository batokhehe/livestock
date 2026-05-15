import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../purchase_order_provider.dart';

final purchaseInvoiceDownloadProgressProvider = StateProvider.family<double, int>(
  (ref, id) => 0.0,
);

final purchaseInvoiceDownloaderProvider = Provider((ref) => PurchaseInvoiceDownloader(ref));

class PurchaseInvoiceDownloader {
  final Ref ref;
  PurchaseInvoiceDownloader(this.ref);

  Future<String?> downloadInvoice(int id, String fileName) async {
    try {
      final api = ref.read(purchaseOrderApiProvider);

      final tempDir = await getTemporaryDirectory();
      final savePath = "${tempDir.path}/$id-$fileName";

      await api
          .downloadPurchaseInvoice(
            id,
            onProgress: (received, total) {
              if (total != -1) {
                final progress = received / total;
                ref.read(purchaseInvoiceDownloadProgressProvider(id).notifier).state =
                    progress;
              }
            },
          )
          .then((response) async {
            final File file = File(savePath);
            await file.writeAsBytes(response.data);
          });

      ref.read(purchaseInvoiceDownloadProgressProvider(id).notifier).state = 0.0;

      return savePath;
    } catch (e) {
      ref.read(purchaseInvoiceDownloadProgressProvider(id).notifier).state = 0.0;
      rethrow;
    }
  }
}
