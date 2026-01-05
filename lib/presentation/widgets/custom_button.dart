import 'package:flutter/material.dart';
import 'package:cots/design_system/styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
            : Text(label, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600)),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
          : Text(label, style: AppTextStyles.button),
    );
  }
}