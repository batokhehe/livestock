import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/card_wrapper.dart';

class EmployeeAttendanceBottomSheet extends StatelessWidget {
  const EmployeeAttendanceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Absensi Pekerja", style: AppTypography.largeBoldBlack),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _menuItem(
            icon: AppImages.icMenuUserTick,
            title: "Lakukan Absen",
            subtitle: "Catat kehadiran hari ini",
            onTap: () {
              context.push('/employee-attendance');
            },
          ),
          SizedBox(height: 8),
          _menuItem(
            icon: AppImages.icMenuClipboardTick,
            title: "Riwayat Absen",
            subtitle: "Lihat daftar absen sebelumnya",
            onTap: () {
              context.push('/history-attendance');
            },
          ),
          SizedBox(height: 8),
          _menuItem(
            icon: AppImages.icMenuTaskSquare,
            title: "Nginap Pekerja",
            subtitle: "Catat informasi menginap",
            onTap: () {
              context.push('/employee-overnight');
            },
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CardWrapper(
        child: Row(
          children: [
            Image.asset(icon, width: 44),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.mediumBoldBlack),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.xSmallNormalBlack),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
