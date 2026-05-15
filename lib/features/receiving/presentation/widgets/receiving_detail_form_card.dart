import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livestock/core/theme/AppColors.dart';
import 'package:livestock/core/theme/AppImages.dart';
import 'package:livestock/core/theme/AppTypography.dart';
import 'package:livestock/core/widgets/info_tag.dart';
import 'package:livestock/core/widgets/input_field_card.dart';
import 'package:livestock/features/receiving/receiving_provider.dart';

import '../../../../core/helpers/utils.dart';
import '../../data/model/receiving_item_model.dart';

class ReceivingDetailFormCard extends ConsumerWidget {
  final ReceivingItem item;
  final VoidCallback onToggle;
  final ValueChanged<String>? onItemCodeChanged;
  final ValueChanged<String>? onWeightChanged;
  final ValueChanged<String>? onNotesChanged;

  const ReceivingDetailFormCard({
    super.key,
    required this.item,
    required this.onToggle,
    this.onItemCodeChanged,
    this.onWeightChanged,
    this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(receivingTabProvider);
    final bool hasInput =
        onItemCodeChanged != null ||
        onWeightChanged != null ||
        onNotesChanged != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.purchOrderNo, style: AppTypography.smallBoldBlack),

              /// ✅ CHECKLIST
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.selected
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.fieldBorder.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: item.selected ? AppColors.success : AppColors.grey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(item.itemName, style: AppTypography.xSmallNormalGrey),

          const SizedBox(height: 8),
          if (type == ReceivingTab.animal)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                InfoTag(
                  label:
                      'Rp ${formatPrice(double.parse(item.subtotal).toInt())}',
                ),
              ],
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [InfoTag(label: '${item.qtyRemaining} ${item.uom}')],
            ),

          /// ✅ INPUT (HANYA JIKA ADA)
          if (hasInput) ...[
            const SizedBox(height: 8),
            Divider(height: 1, color: AppColors.fieldBorder),
            const SizedBox(height: 8),

            Opacity(
              opacity: item.selected ? 1 : 0.5,
              child: IgnorePointer(
                ignoring: !item.selected,
                child: Column(
                  children: [
                    if (onItemCodeChanged != null)
                      TextFields(
                        label: "Kode Hewan",
                        hint: "Masukkan kode",
                        onChanged: onItemCodeChanged,
                        initial: item.itemCode,
                      ),

                    if (onWeightChanged != null) ...[
                      const SizedBox(height: 8),
                      TextFields(
                        label: onItemCodeChanged != null
                            ? "Berat Diterima"
                            : "Jumlah Diterima",
                        hint: onItemCodeChanged != null ? "Berat" : "Jumlah",
                        suffix: onItemCodeChanged != null ? "kg" : null,
                        initial: onItemCodeChanged != null
                            ? item.receivedWeight?.toString()
                            : item.qty,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9\.\,]'),
                          ),
                        ],
                        onChanged: onWeightChanged,
                      ),
                    ],

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showNoteBottomSheet(context, ref),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppImages.icNote,
                                  width: 18,
                                  color: (item.notes ?? '').isNotEmpty
                                      ? AppColors.primary
                                      : AppColors.hint,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    (item.notes ?? '').isNotEmpty
                                        ? item.notes!
                                        : "Tambah catatan",
                                    style: (item.notes ?? '').isNotEmpty
                                        ? AppTypography.xSmallNormalPrimary
                                        : AppTypography.xSmallNormalGrey,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (type == ReceivingTab.animal) ...[
                          const SizedBox(width: 12),
                          _uploadWidget(context, ref),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _uploadWidget(BuildContext context, WidgetRef ref) {
    final hasImage = item.proofImage != null;

    return GestureDetector(
      onTap: () => _showUploadOptions(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hasImage
              ? AppColors.success.withOpacity(0.1)
              : AppColors.primaryShade,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasImage
                ? AppColors.success.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasImage ? Icons.image : Icons.camera_alt,
              size: 14,
              color: hasImage ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              hasImage ? "Lihat Bukti" : "Unggah",
              style: AppTypography.xSmallBoldPrimary.copyWith(
                color: hasImage ? AppColors.success : AppColors.primary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteBottomSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: item.notes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catatan untuk ${item.itemName}",
                style: AppTypography.mediumBoldBlack,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Masukkan catatan",
                  border: OutlineInputBorder(),
                ),
                maxLength: 80,
                autofocus: true,
              ),
              const SizedBox(height: 16),
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
                  onPressed: () {
                    ref
                        .read(receivingFormProvider)
                        .updateNotes(item.id, controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Simpan Catatan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadOptions(BuildContext context, WidgetRef ref) {
    if (item.proofImage != null) {
      _showPreviewDialog(context, ref);
      return;
    }

    _pickImageOptions(context, ref);
  }

  void _pickImageOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Pilih Sumber Gambar",
                  style: AppTypography.mediumBoldBlack,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildUploadOption(
                        icon: Icons.camera_alt_rounded,
                        label: "Kamera",
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera, ref);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUploadOption(
                        icon: Icons.photo_library_rounded,
                        label: "Galeri",
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery, ref);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 12),
            Text(label, style: AppTypography.smallBoldBlack),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, WidgetRef ref) async {
    final picker = ImagePicker();
    try {
      final XFile? picked = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (picked != null) {
        ref
            .read(receivingFormProvider)
            .updateProofImage(item.id, File(picked.path));
      }
    } catch (_) {}
  }

  void _showPreviewDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.file(item.proofImage!, fit: BoxFit.contain),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ref
                                  .read(receivingFormProvider)
                                  .updateProofImage(item.id, null);
                              Navigator.pop(dialogContext);
                            },
                            child: const Text("Hapus"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _pickImageOptions(context, ref);
                            },
                            child: const Text("Ganti"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(dialogContext),
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
