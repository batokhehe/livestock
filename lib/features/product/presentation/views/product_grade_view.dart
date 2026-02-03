import 'package:flutter/material.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';
import '../widgets/filter_dropdown.dart';
import '../widgets/product_grade_card.dart';
import '../widgets/product_group_bottom_sheet.dart';

class ProductGradeView extends StatelessWidget {
  const ProductGradeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _filterGrade(),
        const SizedBox(height: 16),
        _summaryCard(),
        const SizedBox(height: 12),

        ...List.generate(
          5,
              (index) =>
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _openProductGroupSheet(context);
                },
                child: const ProductGradeCard(
                  grade: "Kelas A",
                  weightRange: "200–250kg",
                  total: "300 Sapi",
                  available: "150",
                  sold: "150",
                ),
              ),
        ),
      ],
    );
  }

  void _openProductGroupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProductGroupBottomSheet(),
    );
  }

  Widget _filterGrade() {
    return Row(children: const [FilterDropdown(label: "Semua Kelas")]);
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("4 Kelas Sapi", style: AppTypography.smallNormalBlack),
              const SizedBox(height: 4),
              Text(
                "750 Tersedia • 750 Terjual",
                style: AppTypography.smallNormalGrey,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("1500 Sapi", style: AppTypography.xSmallNormalPrimary),
          ),
        ],
      ),
    );
  }
}
