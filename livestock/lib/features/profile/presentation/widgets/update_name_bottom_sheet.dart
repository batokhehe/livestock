import 'package:flutter/material.dart';
import 'package:livestock/features/profile/presentation/widgets/update_confirmation_bottom_sheet.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class UpdateNameBottomSheet extends StatefulWidget {
  final String currentName;

  const UpdateNameBottomSheet({super.key, required this.currentName});

  @override
  State<UpdateNameBottomSheet> createState() => _UpdateNameBottomSheetState();
}

class _UpdateNameBottomSheetState extends State<UpdateNameBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== HEADER =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Perbarui Data",
                  style: AppTypography.largeBoldBlack,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== FIELD =====
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Nama Akun", style: AppTypography.smallBoldBlack),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Masukkan nama akun",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.fieldBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== BUTTON =====
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
                onPressed: () async {
                  final newName = _controller.text.trim();
                  if (newName.isEmpty) return;

                  final confirmed = await showConfirmUpdateBottomSheet(context);

                  if (confirmed == true) {
                    Navigator.pop(context, newName); // lanjut ke API
                  }
                },
                child: const Text(
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

  void _submit(BuildContext context) {
    final newName = _controller.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nama tidak boleh kosong")));
      return;
    }

    // TODO: hit API update profile
    // contoh:
    // context.read(profileProvider.notifier).updateName(newName);

    Navigator.pop(context, newName); // return value
  }
}
