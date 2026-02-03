import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../home/presentation/views/main_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Notifikasi", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Apapun",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                NotificationItem(
                  type: NotificationType.error,
                  title: "Terjadi Kesalahan",
                  message:
                      "Gagal memproses data. Periksa kembali inputan anda.",
                  time: "14:32",
                ),
                NotificationItem(
                  type: NotificationType.info,
                  title: "Informasi",
                  message:
                      "Ada hal yang perlu kamu perhatikan sebelum melanjutkan.",
                  time: "14:32",
                ),
                NotificationItem(
                  type: NotificationType.info,
                  title: "Informasi",
                  message:
                      "Ada hal yang perlu kamu perhatikan sebelum melanjutkan.",
                  time: "14:32",
                ),
                NotificationItem(
                  type: NotificationType.success,
                  title: "Berhasil",
                  message: "Data telah disimpan dan diperbarui di sistem.",
                  time: "14:32",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum NotificationType { error, info, success }

class NotificationItem extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String message;
  final String time;

  const NotificationItem({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final icon = _icon;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(width: 12),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(title, style: AppTypography.smallBoldBlack)],
                ),
                const SizedBox(height: 4),
                Text("$time • $message", style: AppTypography.xSmallNormalGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _color {
    switch (type) {
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
    }
  }

  IconData get _icon {
    switch (type) {
      case NotificationType.error:
        return Icons.close;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.success:
        return Icons.check;
    }
  }
}
