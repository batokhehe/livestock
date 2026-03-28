import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/AppColors.dart';
import '../theme/AppImages.dart';

class SearchBarCard extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final bool resetPadding;

  const SearchBarCard({
    super.key,
    required this.hint,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.showFilter = false,
    this.resetPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: resetPadding ? EdgeInsets.zero : const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final hasText = value.text.isNotEmpty;
                return TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                      child: SvgPicture.asset(
                        AppImages.icSearch,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    suffixIcon: hasText
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              controller.clear();
                              onClear?.call();
                            },
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.fieldBorder,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryDark,
                        width: 2.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
      ),
    );
  }
}
