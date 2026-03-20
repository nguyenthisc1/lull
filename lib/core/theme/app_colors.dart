import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color surface = Color(0xFF0D0D1A);
  static const Color surfaceVariant = Color(0xFF13132A);
  static const Color surfaceElevated = Color(0xFF1A1A30);

  // ── Primary / Accent ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFFCEB1FF);
  static const Color primaryContainer = Color(0xFFC2A0FC);
  static const Color onPrimary = Color(0xFF1A0040);

  // ── Secondary ─────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF8B9BE8);
  static const Color secondaryContainer = Color(0xFF1E1E3C);
  static const Color onSecondary = Color(0xFF0D0D1A);

  // ── Tertiary ──────────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFFB8D4FF);
  static const Color tertiaryContainer = Color(0xFF1A2A4A);

  // ── Neutrals ──────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFFE8E0FF);
  static const Color onSurfaceVariant = Color(0xFFB0A8D0);
  static const Color outline = Color(0xFF3A3A5C);
  static const Color outlineVariant = Color(0xFF2A2A45);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF6B8A);
  static const Color onError = Color(0xFF3D0014);

  // ── Glassmorphism ─────────────────────────────────────────────────────────
  /// Surface at 60 % opacity for glass overlays.
  static const Color glass = Color(0x990D0D1A);
  static const Color glassBorder = Color(0x33CEB1FF);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const List<Color> backgroundGradient = [
    Color(0xFF0D0D1A),
    Color(0xFF12102B),
    Color(0xFF0D1020),
  ];

  static const List<Color> primaryGradient = [
    Color(0xFFCEB1FF),
    Color(0xFF8B9BE8),
  ];
}
