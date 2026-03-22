import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/shared/widgets/glass_container.dart';

class PlayerWaveform extends StatelessWidget {
  const PlayerWaveform({
    super.key,
    required this.controller,
    required this.isPlaying,
  });

  final AnimationController controller;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, _) => CustomPaint(
          size: const Size(double.infinity, 78),
          painter: WaveformPainter(
            progress: controller.value,
            isPlaying: isPlaying,
          ),
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  const WaveformPainter({required this.progress, required this.isPlaying});

  final double progress;
  final bool isPlaying;

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 30;
    const barGap = 2.5;
    final barWidth = (size.width - (barCount - 1) * barGap) / barCount;
    final phase = progress * 2 * math.pi;

    for (int i = 0; i < barCount; i++) {
      final t = i / barCount;

      final heightFactor = isPlaying
          ? (0.15 +
                  math.sin(phase + t * 12) * 0.18 +
                  math.sin(phase * 1.7 + t * 7) * 0.12 +
                  math.sin(phase * 0.5 + t * 20) * 0.08 +
                  0.4)
              .clamp(0.08, 0.95)
          : (0.08 + math.sin(t * math.pi) * 0.06);

      final barH = size.height * heightFactor;
      final x = i * (barWidth + barGap);
      final y = (size.height - barH) / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barH),
        const Radius.circular(3),
      );

      final alpha = 0.45 + math.sin(t * math.pi) * 0.55;
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: alpha),
            AppColors.secondary.withValues(alpha: alpha * 0.60),
          ],
        ).createShader(Rect.fromLTWH(x, y, barWidth, barH))
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter old) =>
      progress != old.progress || isPlaying != old.isPlaying;
}
