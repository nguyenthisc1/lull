import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/shared/widgets/glass_container.dart';
import 'active_sound.dart';

class SoundMixer extends StatelessWidget {
  const SoundMixer({
    super.key,
    required this.sounds,
    required this.volumes,
    required this.onVolumeChanged,
  });

  final List<ActiveSound> sounds;
  final Map<String, double> volumes;
  final void Function(String id, double volume) onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
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
            children: List.generate(sounds.length, (i) {
              final sound = sounds[i];
              return Column(
                children: [
                  SoundVolumeRow(
                    sound: sound,
                    volume: volumes[sound.id] ?? 0.5,
                    onChanged: (v) => onVolumeChanged(sound.id, v),
                  ),
                  if (i < sounds.length - 1)
                    Divider(
                      color: AppColors.outline.withValues(alpha: 0.40),
                      height: 1,
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

  final ActiveSound sound;
  final double volume;
  final ValueChanged<double> onChanged;

  Color get _categoryColor => switch (sound.category) {
        SoundCategory.rain => AppColors.tertiary,
        SoundCategory.thunder => AppColors.secondary,
        SoundCategory.nature => const Color(0xFF7EC8A0),
        SoundCategory.whiteNoise => AppColors.onSurfaceVariant,
        SoundCategory.urban => const Color(0xFFE8A870),
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Category icon chip
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _categoryColor.withValues(alpha: 0.12),
              borderRadius: DesignTokens.borderRadiusSm,
            ),
            child: Icon(
              sound.icon,
              size: DesignTokens.iconSm,
              color: _categoryColor,
            ),
          ),
          const SizedBox(width: 12),
          // Sound name
          Expanded(
            flex: 2,
            child: Text(
              sound.name,
              style: AppTypography.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Volume slider
          Expanded(
            flex: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: _categoryColor,
                inactiveTrackColor: AppColors.outline.withValues(alpha: 0.40),
                thumbColor: _categoryColor,
                overlayColor: _categoryColor.withValues(alpha: 0.15),
              ),
              child: Slider(value: volume, onChanged: onChanged),
            ),
          ),
          const SizedBox(width: 6),
          // Volume level icon
          Icon(
            volume == 0
                ? Icons.volume_off_rounded
                : volume < 0.5
                    ? Icons.volume_down_rounded
                    : Icons.volume_up_rounded,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
