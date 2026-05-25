import 'package:flutter/material.dart';
import 'package:luxelaptops/core/layout/responsive.dart';

/// Centers content and caps width for a professional web layout.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final padding = AppBreakpoints.horizontalPadding(context);
    return Align(
      alignment: alignment,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: child,
          ),
        ),
      ),
    );
  }
}
