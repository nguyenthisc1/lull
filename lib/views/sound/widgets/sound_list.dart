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
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.spacing6,
          DesignTokens.spacing5,
          DesignTokens.spacing6,
          DesignTokens.spacing3,
        ),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: soundState.sounds
                .map<Widget>((sound) => _SoundListItem(sound: sound))
                .toList(),
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

/// Each item is its own [ConsumerWidget] so only the tapped sound rebuilds
/// when audio state changes — not the entire list.
class _SoundListItem extends ConsumerWidget {
  const _SoundListItem({required this.sound});

  final SoundItem sound;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = colorForCategory(sound);

    final isPlaying = ref.watch(
      audioProvider.select((s) {
        if (s is AudioMixing) {
          return s.mixerSounds[sound.id]?.playbackState ==
              PlaybackState.playing;
        }
        return s.currentSingle?.sound.id == sound.id &&
            s.currentSingle?.playbackState == PlaybackState.playing;
      }),
    );

    final audioNotifier = ref.read(audioProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        color: AppColors.primaryContainer.withValues(alpha: 0.08),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing3,
              ),
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
            onTogglePlay: () => audioNotifier.handleToggleSound(sound),
            glowAlpha: 0,
            size: DesignTokens.iconXl,
            iconSize: DesignTokens.iconMd,
          ),
          const SizedBox(width: DesignTokens.spacing1),
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              size: DesignTokens.iconLg,
            ),
            onPressed: () {},
            splashRadius: DesignTokens.radiusLg,
          ),
        ],
      ),
    );
  }
}
