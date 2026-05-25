import 'package:flutter/material.dart';

/// Breakpoints and spacing for Flutter web layout.
abstract final class AppBreakpoints {
  static const double maxContentWidth = 1280;
  static const double wideSidebar = 900;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 32;
    if (width >= 600) return 24;
    return 16;
  }

  static int productGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return 3;
    if (width >= 720) return 2;
    return 1;
  }

  static bool useSidebarLayout(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= wideSidebar;
}
