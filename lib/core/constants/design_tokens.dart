import 'package:flutter/material.dart';

abstract final class DesignTokens {
  static const double navHeight = 77.0;
  static const double navHeightSpacing = 100.0;

  // ── Border Radius ─────────────────────────────────────────────────────────
  static const double radiusXxl = 64.0;
  static const double radiusXl = 48.0;
  static const double radiusLg = 32.0;
  static const double radiusMd = 20.0;
  static const double radiusSm = 12.0;
  static const double radiusXs = 8.0;
  static const double radiusChip = 9999.0;

  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusChip = BorderRadius.all(
    Radius.circular(radiusChip),
  );

  // ── Spacing ───────────────────────────────────────────────────────────────
  /// 4 px
  static const double spacing1 = 4.0;

  /// 8 px
  static const double spacing2 = 8.0;

  /// 12 px
  static const double spacing3 = 12.0;

  /// 16 px
  static const double spacing4 = 16.0;

  /// 20 px
  static const double spacing5 = 20.0;

  /// 32 px — screen edge padding baseline
  static const double spacing6 = 32.0;

  /// 48 px
  static const double spacing8 = 48.0;

  /// 64 px
  static const double spacing10 = 64.0;

  // ── Glassmorphism ─────────────────────────────────────────────────────────
  static const double glassOpacity = 0.60;
  static const double glassBlur = 20.0;

  // ── Animation ─────────────────────────────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 600);

  /// Slow, smooth cubic-bezier matching the design spec (0.4, 0, 0.2, 1).
  static const Curve curveStandard = Curves.easeInOutCubic;

  // ── Elevation / Shadow ────────────────────────────────────────────────────
  static List<BoxShadow> get shadowSm => const [
    BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static List<BoxShadow> get shadowMd => const [
    BoxShadow(color: Color(0x50000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static List<BoxShadow> get shadowLg => const [
    BoxShadow(color: Color(0x60000000), blurRadius: 48, offset: Offset(0, 16)),
  ];

  static List<BoxShadow> get glowPrimary => const [
    BoxShadow(color: Color(0x55CEB1FF), blurRadius: 32, offset: Offset(0, 0)),
  ];

  // ── Icon Sizes ────────────────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // ── Sleep Slider ──────────────────────────────────────────────────────────
  static const double sliderTrackHeight = 12.0;
  static const double sliderThumbRadius = 14.0;
}
