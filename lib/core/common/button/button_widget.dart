import 'package:flutter/material.dart';

import '../../themes/app_color.dart';
import '../../themes/text_style.dart';
import '../../widgets/loading_shimmer.dart';

extension ButtonStyleExtensions on BuildContext {
  Widget primaryButton({
    required VoidCallback onPressed,
    required String text,
    double? width,
    double? height,
    bool isLoading = false,
    IconData? icon,
    double borderRadius = 8,
    Color? backgroundColor,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 51,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: LoadingShimmer(size: 24, color: Colors.black),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppText.mdMedium_16.copyWith(color: Colors.white),
                  ),
                  if (icon != null) ...[
                    SizedBox(width: 8),
                    Icon(icon, size: 20, color: Colors.black),
                  ],
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required Null Function() onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Center(
        child: Text(
          'Message Local',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
