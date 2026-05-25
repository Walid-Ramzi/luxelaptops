import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';

/// Consistent product / hero image with loading and error fallbacks.
class AssetImageBox extends StatelessWidget {
  const AssetImageBox({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.height,
    this.width,
  });

  final String asset;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.zero;
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: width,
        child: Image.asset(
          asset,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.cardElevated,
            alignment: Alignment.center,
            child: const Icon(Icons.laptop_mac_rounded, color: AppColors.textSecondary, size: 40),
          ),
        ),
      ),
    );
  }
}
