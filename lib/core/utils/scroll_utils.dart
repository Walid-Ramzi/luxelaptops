import 'package:flutter/material.dart';

/// Smooth scroll to a section identified by [key].
Future<void> scrollToSection(GlobalKey key, {Duration? duration}) async {
  final context = key.currentContext;
  if (context == null) return;
  await Scrollable.ensureVisible(
    context,
    duration: duration ?? const Duration(milliseconds: 650),
    curve: Curves.easeInOutCubic,
    alignment: 0.05,
  );
}
