import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/shared/utils/utils.dart';
import 'package:lull/shared/widgets/glass_container.dart';

class SoundMixer extends ConsumerWidget {
  const SoundMixer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsList = ref.watch(audioProvider.select((s) => s.sounds));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
          child: Text(
            'MIXER',
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
                  SoundVolumeRow(
                    sound: soundItemState.sound,
                    volume: soundItemState.volume,
                    onChanged: (v) {
                      // Find the provider logic to change volume
                      // ref.read(audioProvider.notifier).setVolume(sound.id, v);
                    },
                  ),
                  if (i < soundsList.length - 1)
                    Divider(
                      color: AppColors.outline.withValues(alpha: .40),
                      height: DesignTokens.spacing1,
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

// ── Individual sound row ──────────────────────────────────────────────────────

class SoundVolumeRow extends StatelessWidget {
  const SoundVolumeRow({
    super.key,
    required this.sound,
    required this.volume,
    required this.onChanged,
  });

  final SoundItem sound;
  final double volume;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = colorForCategory(sound);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacing3),
      child: Row(
        children: [
          // Category icon chip
          Container(
            width: DesignTokens.iconXl,
            height: DesignTokens.iconXl,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: .12),
              borderRadius: DesignTokens.borderRadiusSm,
            ),
            child: Icon(
              iconForCategory(sound),
              size: DesignTokens.iconLg,
              color: categoryColor,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),
          // Sound name
          Expanded(
            flex: 2,
            child: Text(
              sound.name,
              style: AppTypography.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing2),

          Expanded(
            flex: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: DesignTokens.spacing1,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: categoryColor,
                inactiveTrackColor: AppColors.outline.withValues(alpha: .40),
                thumbColor: categoryColor,
                overlayColor: categoryColor.withValues(alpha: .15),
              ),
              child: Slider(value: volume, onChanged: onChanged),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing1),
          // Volume level icon
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
    );
  }
}
