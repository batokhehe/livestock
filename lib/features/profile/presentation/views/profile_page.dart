import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/info_item_card.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../home/presentation/views/main_page.dart';
import '../../../user/providers/user_provider.dart';
import '../widgets/logout_confirmation_bottom_sheet.dart';
import '../widgets/success_banner.dart';
import '../widgets/update_name_bottom_sheet.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Profil", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileCard(userName),
                  const SizedBox(height: 16),
                  _infoSection(context, userName),
                  const SizedBox(height: 24),
                  _logoutButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _profileCard(String userName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(AppImages.icUserTag, width: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: AppTypography.smallBoldBlack),
                const SizedBox(height: 2),
                Text("kepala kandang", style: AppTypography.xSmallNormalGrey),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Aktif",
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO SECTION =================
  Widget _infoSection(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informasi Pekerja", style: AppTypography.smallBoldBlack),
          const SizedBox(height: 12),
          InfoItemCard(
            icon: AppImages.icUserEdit,
            title: userName,
            subtitle: "Nama Akun",
            onTap: () async {
              final result = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => UpdateNameBottomSheet(currentName: userName),
              );

              if (result != null) {
                // 🔥 HIT API UPDATE DI SINI
                await Future.delayed(
                  const Duration(milliseconds: 800),
                ); // simulasi API

                showSuccessBanner(context);
              }
            },
          ),

          InfoItemCard(
            icon: AppImages.icCalling,
            title: "0861-2345-6789",
            subtitle: "Nomor Telepon",
          ),
          InfoItemCard(
            icon: AppImages.icMessageTick,
            title: "ninaputri@gmail.com",
            subtitle: "Alamat Email",
          ),
          InfoItemCard(
            icon: AppImages.icField,
            title: "Sapi Agri Banten",
            subtitle: "Lokasi Peternakan",
          ),
          InfoItemCard(
            icon: AppImages.icLock,
            title: "Perubahan Kata sandi",
            subtitle: "Ganti kata sandi?",

            onTap: () async {
              final result = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => UpdateNameBottomSheet(currentName: userName),
              );

              if (result != null) {
                // 🔥 HIT API UPDATE DI SINI
                await Future.delayed(
                  const Duration(milliseconds: 800),
                ); // simulasi API

                showSuccessBanner(context);
              }
            },
          ),
        ],
      ),
    );
  }

  // ================= LOGOUT =================
  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          showLogoutBottomSheet(context);
        },
        child: const Text(
          "Keluar Aplikasi",
          style: AppTypography.mediumBoldWhite,
        ),
      ),
    );
  }
}

void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const LogoutConfirmationBottomSheet(),
  );
}
