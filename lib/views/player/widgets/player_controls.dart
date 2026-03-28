import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/shared/widgets/control_button.dart';
import 'package:lull/shared/widgets/player_button.dart';

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
          builder: (_, __) {
            return PlayerButton(
              isPlaying: isPlaying,
              onTogglePlay: onTogglePlay,
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
