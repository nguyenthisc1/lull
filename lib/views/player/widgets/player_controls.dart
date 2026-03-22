import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.pulseController,
    required this.onTogglePlay,
    required this.onStopAll,
  });

  final bool isPlaying;
  final AnimationController pulseController;
  final VoidCallback onTogglePlay;
  final VoidCallback onStopAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          icon: Icons.shuffle_rounded,
          onTap: () {},
          size: 44,
          iconSize: DesignTokens.iconMd,
          color: AppColors.onSurfaceVariant,
        ),
        const SizedBox(width: DesignTokens.spacing5),
        // Central play/pause with animated glow
        AnimatedBuilder(
          animation: pulseController,
          builder: (_, _) {
            final glowAlpha = isPlaying
                ? (0.25 + pulseController.value * 0.25)
                : 0.0;
            return Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: glowAlpha),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ControlButton(
                icon: isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                onTap: onTogglePlay,
                size: 72,
                iconSize: 36,
                color: AppColors.onPrimary,
                filled: true,
              ),
            );
          },
        ),
        const SizedBox(width: DesignTokens.spacing5),
        ControlButton(
          icon: Icons.stop_circle_outlined,
          onTap: onStopAll,
          size: 44,
          iconSize: DesignTokens.iconMd,
          color: AppColors.onSurfaceVariant,
        ),
      ],
    );
  }
}

// ── Reusable circular icon button ─────────────────────────────────────────────

class ControlButton extends StatelessWidget {
  const ControlButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
    required this.color,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: filled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                )
              : null,
          color: filled ? null : AppColors.surfaceVariant,
          border: filled
              ? null
              : Border.all(
                  color: AppColors.outline.withValues(alpha: 0.60),
                  width: 1,
                ),
        ),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}
