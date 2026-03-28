import 'package:flutter/material.dart';

import '../theme/AppColors.dart';
import '../theme/AppImages.dart';
import '../theme/AppTypography.dart';

class SearchBarCard extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  const SearchBarCard({
    super.key,
    required this.hint,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.showFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ===== SEARCH FIELD =====
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final hasText = value.text.isNotEmpty;

                return TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.hint,
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: hasText
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              controller.clear();
                              onClear?.call();
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ),

        // ===== FILTER BUTTON =====
        if (showFilter) ...[
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onFilterTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(AppImages.icFilterSearch, width: 24),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
