import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/shared/utils/utils.dart';
import 'package:lull/shared/widgets/glass_container.dart';

class SoundMixer extends ConsumerWidget {
  const SoundMixer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsList = ref.watch(audioProvider.select((s) => s.sounds));
    final mode = ref.watch(audioModeProvider);

    if (soundsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
          child: Text(
            mode == AudioMode.mixing ? 'MIXER' : 'NOW PLAYING',
            style: AppTypography.labelSmall.copyWith(
              letterSpacing: 2.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        GlassContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing4,
            vertical: DesignTokens.spacing3,
          ),
          child: Column(
            children: List.generate(soundsList.length, (i) {
              final soundItemState = soundsList[i];
              return Column(
                children: [
                  SoundMixerRow(
                    soundItemState: soundItemState,
                    isMixing: mode == AudioMode.mixing,
                    onVolumeChanged: (v) => ref
                        .read(audioProvider.notifier)
                        .setVolume(soundItemState, v),
                    onTogglePlay: () => ref
                        .read(audioProvider.notifier)
                        .toggleMixerSound(soundItemState),
                    onRemove: mode == AudioMode.mixing
                        ? () => ref
                              .read(audioProvider.notifier)
                              .removeFromMix(soundItemState.sound)
                        : null,
                  ),
                  if (i < soundsList.length - 1)
                    Divider(
                      color: AppColors.outline.withValues(alpha: 0.30),
                      height: DesignTokens.spacing3,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ── Individual mixer row ──────────────────────────────────────────────────────

class SoundMixerRow extends StatelessWidget {
  const SoundMixerRow({
    super.key,
    required this.soundItemState,
    required this.isMixing,
    required this.onVolumeChanged,
    required this.onTogglePlay,
    this.onRemove,
  });

  final AudioItemState soundItemState;
  final bool isMixing;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onTogglePlay;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final sound = soundItemState.sound;
    final categoryColor = colorForCategory(sound);
    final isPlaying = soundItemState.playbackState == PlaybackState.playing;
    final volume = soundItemState.volume ?? 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Category icon
          Container(
            width: DesignTokens.iconXl,
            height: DesignTokens.iconXl,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.12),
              borderRadius: DesignTokens.borderRadiusSm,
            ),
            child: Icon(
              iconForCategory(sound),
              size: DesignTokens.iconMd,
              color: categoryColor,
            ),
          ),

          const SizedBox(width: DesignTokens.spacing3),

          // Name + volume slider
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sound.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // Play / pause button
                    Row(
                      children: [
                        _MixerIconButton(
                          icon: isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: categoryColor,
                          onTap: onTogglePlay,
                        ),

                        // Remove button (mixing mode only)
                        if (onRemove != null) ...[
                          const SizedBox(width: DesignTokens.spacing2),
                          _MixerIconButton(
                            icon: Icons.close_rounded,
                            color: Theme.of(context).colorScheme.error,
                            onTap: onRemove!,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacing2),
                Row(
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          activeTrackColor: categoryColor,
                          inactiveTrackColor: AppColors.outline.withValues(
                            alpha: 0.30,
                          ),
                          thumbColor: categoryColor,
                          overlayColor: categoryColor.withValues(alpha: 0.15),
                        ),
                        child: Slider(
                          value: volume,
                          onChanged: onVolumeChanged,
                        ),
                      ),
                    ),
                    Icon(
                      volume == 0
                          ? Icons.volume_off_rounded
                          : volume < 0.5
                          ? Icons.volume_down_rounded
                          : Icons.volume_up_rounded,
                      size: DesignTokens.iconSm,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small circular icon button ────────────────────────────────────────────────

class _MixerIconButton extends StatelessWidget {
  const _MixerIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.12),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ── Keep old name as alias so any external references still compile ───────────
typedef SoundVolumeRow = SoundMixerRow;
