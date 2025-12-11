import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/core/theme/AppColors.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../core/widgets/error_dialog.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  bool _obscure = true;

  void _doLogin() {
    final email = _email.text.trim();
    final pass = _pass.text.trim();

    if (email.isEmpty) {
      showError(context, "Email tidak boleh kosong");
      return;
    }
    if (!email.contains('@')) {
      showError(context, "Format email tidak valid");
      return;
    }
    if (pass.isEmpty) {
      showError(context, "Password tidak boleh kosong");
      return;
    }

    ref.read(loginViewModelProvider.notifier).login(email, pass);
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginViewModelProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          context.go('/home');
        },
        error: (error, _) {
          final msg = error is AppException
              ? error.message
              : "Terjadi kesalahan";
          showError(context, msg);
        },
      );
    });

    final loginState = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      body: Stack(
        children: [
          _buildMainUI(),

          if (loginState.isLoading)
            Container(
              color: AppColors.primary,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildMainUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Image.asset(
                    "assets/images/welcome.png",
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Selamat Datang Kembali",
                    style: AppTypography.largeBoldBlack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Kelola peternakan Anda dengan lebih mudah.",
                    style: AppTypography.smallNormalBlack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _label("Nama Akun"),
            _boxField(
              controller: _email,
              hint: "username@email.com",
              icon: Icons.comment,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passFocus);
              },
            ),
            const SizedBox(height: 16),
            _label("Kata sandi"),
            _boxField(
              controller: _pass,
              hint: "Tulis kata sandi akun",
              icon: Icons.lock_outline,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              focusNode: _passFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _doLogin(),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go("/login"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Masuk Livestock",
                  style: AppTypography.mediumBoldWhite,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                "Livestock 1.0",
                style: AppTypography.xSmallNormalBlack,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Column(
      children: [
        Text(text, style: AppTypography.smallBoldBlack),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _boxField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.fieldBorder),
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2)),
      ],
    );
  }
}
