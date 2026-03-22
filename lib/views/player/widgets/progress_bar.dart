import 'package:flutter/material.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';

/// Displays the current playback position as a styled progress slider.
///
/// Wire to SoLoud in production:
/// ```dart
/// position: SoLoud.instance.getPosition(handle),
/// length:   SoLoud.instance.getLength(handle),
/// onSeek:   (pos) => SoLoud.instance.seek(handle, pos),
/// ```
class SoLoudProgressBar extends StatelessWidget {
  const SoLoudProgressBar({
    super.key,
    required this.position,
    required this.length,
    this.onSeek,
  });

  final Duration position;
  final Duration length;
  final void Function(Duration)? onSeek;

  double get _progress =>
      length.inMilliseconds == 0
          ? 0
          : (position.inMilliseconds / length.inMilliseconds).clamp(0.0, 1.0);

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.5,
            thumbShape: GlowThumbShape(),
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.outline.withValues(alpha: 0.35),
            thumbColor: AppColors.primary,
            trackShape: GradientTrackShape(),
          ),
          child: Slider(
            value: _progress,
            onChanged: (v) => onSeek?.call(length * v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Text(_fmt(position), style: AppTypography.bodySmall),
              const Spacer(),
              Text(_fmt(length), style: AppTypography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Glowing thumb ─────────────────────────────────────────────────────────────

class GlowThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(16, 16);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Soft glow ring
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Gradient-filled solid thumb
    canvas.drawCircle(
      center,
      7,
      Paint()
        ..shader = const LinearGradient(
          colors: AppColors.primaryGradient,
        ).createShader(Rect.fromCircle(center: center, radius: 7)),
    );
  }
}

// ── Gradient active track ─────────────────────────────────────────────────────

class GradientTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final radius = Radius.circular(trackRect.height / 2);

    // Inactive (full) track background
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      Paint()..color = sliderTheme.inactiveTrackColor ?? AppColors.outline,
    );

    // Active portion with gradient fill
    final activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );
    if (activeRect.width > 0) {
      context.canvas.drawRRect(
        RRect.fromRectAndCorners(
          activeRect,
          topLeft: radius,
          bottomLeft: radius,
        ),
        Paint()
          ..shader = const LinearGradient(
            colors: AppColors.primaryGradient,
          ).createShader(activeRect),
      );
    }
  }
}
