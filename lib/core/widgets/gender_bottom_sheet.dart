import 'package:flutter/material.dart';
import 'package:livestock/core/theme/AppColors.dart';

class GenderBottomSheet extends StatefulWidget {
  final String? selected;

  const GenderBottomSheet({super.key, this.selected});

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
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Jenis Kelamin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// OPTION LIST
          _item("Jantan", "male"),
          const SizedBox(height: 12),
          _item("Betina", "female"),
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

        Navigator.pop(context, value); // 🔥 return value
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyBg,
            width: 1.5,
          ),
          color: isSelected ? AppColors.primaryShade : AppColors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }
}
