import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/shared/utils/utils.dart';

class PlayerTitle extends ConsumerStatefulWidget {
  const PlayerTitle({super.key});

  @override
  ConsumerState<PlayerTitle> createState() => _PlayerTitleState();
}

class _PlayerTitleState extends ConsumerState<PlayerTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(
        minutes: 1,
      ), // much slower: 1 rotation in 20 minutes
    );
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlayerTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(
      audioProvider.select(
        (s) => s.currentSingle?.playbackState == PlaybackState.playing,
      ),
    );

    final currentSound = ref.watch(
      audioProvider.select(
        (s) => s.currentSingle ?? (s.sounds.isNotEmpty ? s.sounds[0] : null),
      ),
    );

    // Animation: rotate full 360 deg (2 * pi), repeat when isPlaying, stop (no anim) when false.
    if (isPlaying) {
      if (!_rotateCtrl.isAnimating) {
        _rotateCtrl.repeat();
      }
    } else {
      if (_rotateCtrl.isAnimating) {
        _rotateCtrl.stop();
      }
    }

    final title = currentSound?.sound.name ?? '';
    final category = currentSound?.sound.category.name ?? '';
    final color = currentSound != null
        ? colorForCategory(currentSound.sound)
        : AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _rotateCtrl,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateCtrl.value * 2 * 3.14159265359, // 360 degrees
              child: child,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.05),
            ),
            alignment: Alignment.center,
            child: Icon(
              currentSound != null
                  ? iconForCategory(currentSound.sound)
                  : Icons.music_note,
              size: 240,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacing2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignTokens.spacing2),
        Text(
          category,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
