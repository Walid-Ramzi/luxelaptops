import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';

/// Formatted price label with optional accent glow.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.large = false,
    this.showFrom = false,
  });

  final double price;
  final bool large;
  final bool showFrom;

  @override
  Widget build(BuildContext context) {
    final formatted = '\$${price.toStringAsFixed(0)}';
    final style = TextStyle(
      fontSize: large ? 28 : 18,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      foreground: Paint()
        ..shader = AppColors.primaryGlow.createShader(
          const Rect.fromLTWH(0, 0, 200, 40),
        ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (showFrom)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              'from',
              style: TextStyle(
                fontSize: large ? 14 : 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Text(formatted, style: style),
      ],
    );
  }
}
