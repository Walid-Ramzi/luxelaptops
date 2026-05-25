import 'package:flutter/material.dart';
import 'package:luxelaptops/core/constants/colors.dart';

enum CustomButtonVariant { primary, secondary, outline, ghost }

/// Unified CTA used across all screens.
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expanded = false,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expanded;
  final double height;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    final child = AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final scale = _pressed ? 0.96 : (_pulse.value);
        return Transform.scale(
          scale: widget.variant == CustomButtonVariant.primary ? scale : 1,
          child: _buildButton(enabled),
        );
      },
    );

    return widget.expanded
        ? SizedBox(width: double.infinity, height: widget.height, child: child)
        : SizedBox(height: widget.height, child: child);
  }

  Widget _buildButton(bool enabled) {
    final decoration = _decoration(enabled);
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: decoration,
        alignment: Alignment.center,
        child: widget.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 20, color: _foreground(enabled)),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: _foreground(enabled),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  BoxDecoration _decoration(bool enabled) {
    switch (widget.variant) {
      case CustomButtonVariant.primary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: enabled ? AppColors.primaryGlow : null,
          color: enabled ? null : AppColors.card,
          boxShadow: enabled ? AppColors.neonGlow(AppColors.primary, blur: 16) : null,
        );
      case CustomButtonVariant.secondary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: enabled ? AppColors.secondary.withValues(alpha: 0.15) : AppColors.card,
          border: Border.all(
            color: enabled ? AppColors.secondary : AppColors.border,
          ),
          boxShadow: enabled ? AppColors.neonGlow(AppColors.secondary, blur: 12) : null,
        );
      case CustomButtonVariant.outline:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: enabled ? AppColors.primary : AppColors.border),
        );
      case CustomButtonVariant.ghost:
        return BoxDecoration(borderRadius: BorderRadius.circular(14));
    }
  }

  Color _foreground(bool enabled) {
    if (!enabled) return AppColors.textSecondary;
    switch (widget.variant) {
      case CustomButtonVariant.primary:
        return AppColors.background;
      case CustomButtonVariant.secondary:
        return AppColors.secondary;
      case CustomButtonVariant.outline:
      case CustomButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }
}
