import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';

import '../theme/AppTypography.dart';

class GenderBottomSheet extends StatefulWidget {
  final String? selected;
  final String title;
  final String description;

  const GenderBottomSheet({
    super.key,
    this.selected,
    this.title = "Pilih Jenis Kelamin",
    this.description = "Silakan pilih salah satu jenis kelamin.",
  });

  @override
  State<GenderBottomSheet> createState() => _GenderBottomSheetState();
}

class _GenderBottomSheetState extends State<GenderBottomSheet> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(widget.title, style: AppTypography.largeBoldBlack),
          const SizedBox(height: 8),
          Text(widget.description, style: AppTypography.smallNormalGrey),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [_item("Jantan", "male"), _item("Betina", "female")],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
        });

        Navigator.pop(context, value);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: isSelected
                  ? AppTypography.smallBoldBlack
                  : AppTypography.smallNormalBlack,
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
