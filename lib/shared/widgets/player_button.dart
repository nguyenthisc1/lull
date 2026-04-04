import 'package:flutter/material.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/shared/widgets/control_button.dart';

class PlayerButton extends StatelessWidget {
  const PlayerButton({
    super.key,
    required this.isPlaying,
    this.glowAlpha,
    required this.onTogglePlay,
    this.onLongPress,
    this.size = 72,
    this.iconSize = 36,
    this.glowBlurRadius = 32,
    this.glowSpreadRadius = 4,
  });

  final bool isPlaying;
  final double? glowAlpha;
  final VoidCallback onTogglePlay;
  final VoidCallback? onLongPress;

  /// Diameter of the button.
  final double size;

  /// Size of the play/pause icon.
  final double iconSize;

  /// Blur radius for the glow box shadow.
  final double glowBlurRadius;

  /// Spread radius for the glow box shadow.
  final double glowSpreadRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (isPlaying)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: glowAlpha),
              blurRadius: glowBlurRadius,
              spreadRadius: glowSpreadRadius,
            ),
        ],
      ),
      child: ControlButton(
        icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        onTap: onTogglePlay,
        onLongPress: onLongPress,
        size: size,
        iconSize: iconSize,
        color: AppColors.onPrimary,
        filled: true,
      ),
    );
  }
}
