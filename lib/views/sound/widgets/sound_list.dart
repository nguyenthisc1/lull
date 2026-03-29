import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/providers/sound_provider.dart';
import 'package:lull/shared/utils/utils.dart';
import 'package:lull/shared/widgets/player_button.dart';

class SoundList extends ConsumerWidget {
  const SoundList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundState = ref.watch(soundProvider);

    if (soundState is SoundLoading || soundState is SoundInitial) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (soundState is SoundError) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacing3),
          child: Text('Error loading sounds: ${soundState.errorMessage}'),
        ),
      );
    } else if (soundState is SoundLoaded) {
      final soundList = soundState.sounds;
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.spacing6,
          DesignTokens.spacing5,
          DesignTokens.spacing6,
          DesignTokens.spacing3,
        ),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: soundList
                .map<Widget>((sound) => soundItem(sound, ref))
                .toList(),
          ),
        ),
      );
    } else {
      // fallback if needed
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  Widget soundItem(SoundItem sound, WidgetRef ref) {
    final color = colorForCategory(sound);
    final audioNotifier = ref.read(audioProvider.notifier);
    final isPlaying = ref.watch(
      audioProvider.select(
        (s) =>
            s.currentSingle?.sound.id == sound.id &&
            s.currentSingle?.playbackState == PlaybackState.playing,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        color: AppColors.primaryContainer.withValues(alpha: 0.08),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing5,
        vertical: DesignTokens.spacing5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon category (left)
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Icon(
              iconForCategory(sound),
              size: DesignTokens.iconLg,
              color: color,
            ),
          ),
          // Sound name (centered, expanded)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing3,
              ), // 14
              child: Column(
                children: [
                  Text(
                    sound.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: DesignTokens.spacing1),
                  Text(
                    sound.category.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.25,
                      color: AppColors.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          PlayerButton(
            isPlaying: isPlaying,
            onTogglePlay: () => audioNotifier.handlePlaySingle(sound),
            glowAlpha: 0,
            size: DesignTokens.iconXl, // 48
            iconSize: DesignTokens.iconMd, // 24
          ),
          const SizedBox(width: DesignTokens.spacing1),
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              size: DesignTokens.iconLg,
            ),
            onPressed: () {},
            splashRadius: DesignTokens.radiusLg, // 22
          ),
        ],
      ),
    );
  }
}
