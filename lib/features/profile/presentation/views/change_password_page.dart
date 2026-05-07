import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/errors/app_exception.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/error_dialog.dart';
import 'package:livestock/features/auth/providers/auth_provider.dart';
import 'package:livestock/features/home/presentation/widgets/app_text_field.dart';
import 'package:livestock/features/profile/presentation/widgets/update_confirmation_bottom_sheet.dart';
import 'package:livestock/features/user/providers/user_repository_provider.dart';
import '../widgets/success_banner.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kata sandi baru tidak cocok")),
      );
      return;
    }

    final confirm = await showConfirmUpdateBottomSheet(
      context,
      title: "Perbarui Kata Sandi?",
      subtitle:
          "Kata sandi anda akan diperbarui, silakan masuk kembali setelah perubahan berhasil.",
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(userRepositoryProvider)
          .changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
          );

      if (mounted) {
        showSuccessBanner(context);
        await ref.read(logoutProvider).call();
      }
    } catch (e) {
      if (mounted) {
        final message = e is AppException ? e.message : e.toString();
        showError(context, message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Ubah Kata Sandi",
          style: AppTypography.largeBoldBlack,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: "Kata Sandi Lama",
                    hint: "Masukkan kata sandi lama",
                    // prefixIcon: AppImages.icLock,
                    controller: _oldPasswordController,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: "Kata Sandi Baru",
                    hint: "Masukkan kata sandi baru",
                    // prefixIcon: AppImages.icLock,
                    controller: _newPasswordController,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: "Konfirmasi Kata Sandi Baru",
                    hint: "Ulangi kata sandi baru",
                    // prefixIcon: AppImages.icLock,
                    controller: _confirmPasswordController,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSubmit(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: AppTypography.mediumBoldWhite,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
