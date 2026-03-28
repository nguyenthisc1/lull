import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/shared/widgets/glass_container.dart';

class PlayerHeader extends ConsumerWidget {
  const PlayerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundCount = ref.watch(
      audioProvider.select((s) => s.sounds.length),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOW PLAYING',
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 2.5,
                  color: AppColors.primary.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: 4),
              Text('Sound Mix', style: AppTypography.headlineSmall),
            ],
          ),
        ),
        GlassContainer(
          borderRadius: DesignTokens.borderRadiusChip,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.music_note_rounded,
                size: DesignTokens.iconSm,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '$soundCount ${soundCount == 1 ? 'sound' : 'sounds'}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
