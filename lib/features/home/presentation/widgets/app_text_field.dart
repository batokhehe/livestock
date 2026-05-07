import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/AppColors.dart';
import '../../../../core/theme/AppTypography.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? initial;
  final String? suffix;
  final String? prefixText;
  final TextEditingController? controller;
  final int maxLines;
  final bool showCounter;
  final bool enabled;
  final bool isMandatoryField;
  final String? prefixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.initial,
    this.suffix,
    this.prefixText,
    this.controller,
    this.maxLines = 1,
    this.showCounter = false,
    this.enabled = true,
    this.isMandatoryField = false,
    this.prefixIcon,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.isPassword = false,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: widget.enabled
                    ? AppTypography.smallBoldBlack
                    : AppTypography.smallBoldGrey,
              ),
              widget.isMandatoryField
                  ? const Text('*', style: AppTypography.smallBoldRed)
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            initialValue: widget.controller == null ? widget.initial : null,
            controller: widget.controller,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            maxLength: widget.showCounter ? 80 : null,
            style: widget.enabled
                ? AppTypography.smallBoldBlack
                : AppTypography.smallBoldGrey,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.hint,
              counterText: widget.showCounter ? null : "",
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffix != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(widget.suffix!, style: AppTypography.smallNormalGrey),
                        )
                      : null,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(widget.prefixIcon!, width: 18),
                    )
                  : widget.prefixText != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(widget.prefixText!,
                              style: AppTypography.smallBoldBlack),
                        )
                      : null,
              prefixIconConstraints: widget.prefixText != null
                  ? const BoxConstraints(minWidth: 0, minHeight: 0)
                  : null,
              filled: true,
              fillColor: widget.enabled ? AppColors.white : AppColors.greyBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.fieldBorder,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.fieldBorder,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.grey2, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
