import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/widgets/info_item_card.dart';
import 'package:livestock/features/user/providers/user_repository_provider.dart';

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../user/providers/user_provider.dart';
import '../widgets/logout_confirmation_bottom_sheet.dart';
import '../widgets/success_banner.dart';
import '../widgets/update_name_bottom_sheet.dart';
import '../widgets/update_phone_bottom_sheet.dart';
import '../widgets/update_confirmation_bottom_sheet.dart';

import '../../../home/presentation/providers/home_navigation_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final userPhone = ref.watch(userPhoneProvider);
    final userRole = ref.watch(userRoleProvider);
    final userEmail = ref.watch(userEmailProvider);
    final userFarm = ref.watch(userFarmProvider);

    ref.watch(profilePageInitProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Profil", style: AppTypography.largeBoldBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(mainNavIndexProvider.notifier).state = 0;
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
                  _profileCard(userName, userRole),
                  const SizedBox(height: 16),
                  _infoSection(
                    context,
                    ref,
                    userName != "" ? userName : "-",
                    userPhone != "" ? userPhone : "-",
                    userEmail != "" ? userEmail : "-",
                    userFarm != 0 ? userFarm.toString() : "-",
                  ),
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
  Widget _profileCard(String userName, String userRole) {
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
                Text(userRole, style: AppTypography.xSmallNormalGrey),
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
  Widget _infoSection(
    BuildContext context,
    WidgetRef ref,
    String userName,
    String userPhone,
    String userEmail,
    String userFarm,
  ) {
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
                try {
                  await ref
                      .read(userRepositoryProvider)
                      .changeProfile(columnType: "name", newValue: result);

                  ref.invalidate(userProvider);
                  showSuccessBanner(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
          ),

          InfoItemCard(
            icon: AppImages.icCalling,
            title: userPhone,
            subtitle: "Nomor Telepon",
            onTap: () async {
              final result = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => UpdatePhoneBottomSheet(currentPhone: userPhone),
              );

              if (result != null) {
                try {
                  await ref
                      .read(userRepositoryProvider)
                      .changeProfile(columnType: "phone", newValue: result);

                  ref.invalidate(userProvider);
                  showSuccessBanner(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
          ),
          InfoItemCard(
            icon: AppImages.icMessageTick,
            title: userEmail,
            subtitle: "Alamat Email",
          ),
          InfoItemCard(
            icon: AppImages.icField,
            title: userFarm,
            subtitle: "Lokasi Peternakan",
          ),
          InfoItemCard(
            icon: AppImages.icLock,
            title: "Perubahan Kata sandi",
            subtitle: "Ganti kata sandi?",
            onTap: () {
              context.push('/change-password');
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
