import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../../../../features/receiving/receiving_provider.dart';

class UploadFileCard extends ConsumerStatefulWidget {
  const UploadFileCard({super.key});

  @override
  ConsumerState<UploadFileCard> createState() => _UploadFileCardState();
}

class _UploadFileCardState extends ConsumerState<UploadFileCard> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (picked != null) {
        ref.read(receivingFormProvider).setProofImage(File(picked.path));
      }
    } catch (_) {}
  }

  void _showPickOption() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Ambil dari Kamera"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Ambil dari Galeri"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = ref.watch(receivingFormProvider).proofImage;
    final fileName = file != null ? path.basename(file.path) : "Unggah Bukti";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          /// LEFT INFO
          Expanded(
            child: InkWell(
              onTap: _showPickOption,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: AppTypography.smallBoldBlack,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Pastikan bukti terlihat jelas!",
                    style: AppTypography.hint,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// UPLOAD BUTTON
          GestureDetector(
            onTap: file == null
                ? _showPickOption
                : () {
                    // nanti submit / lanjut
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryShade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Unggah", style: AppTypography.smallBoldPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
