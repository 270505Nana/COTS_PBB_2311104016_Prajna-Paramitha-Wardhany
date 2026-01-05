import 'package:flutter/material.dart';
import 'package:cots/design_system/styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.section),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
            filled: true,
            fillColor: AppColors.surface,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}