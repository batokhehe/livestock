import 'package:flutter/material.dart';
import 'package:livestock/features/profile/presentation/widgets/update_confirmation_bottom_sheet.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class UpdatePhoneBottomSheet extends StatefulWidget {
  final String currentPhone;

  const UpdatePhoneBottomSheet({super.key, required this.currentPhone});

  @override
  State<UpdatePhoneBottomSheet> createState() => _UpdatePhoneBottomSheetState();
}

class _UpdatePhoneBottomSheetState extends State<UpdatePhoneBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPhone);
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
              child: Text("Nomor Telepon", style: AppTypography.smallBoldBlack),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Masukkan nomor telepon",
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
                  final newPhone = _controller.text.trim();
                  if (newPhone.isEmpty) return;

                  final confirmed = await showConfirmUpdateBottomSheet(context);

                  if (confirmed == true) {
                    Navigator.pop(context, newPhone);
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
}
