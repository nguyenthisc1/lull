import 'package:flutter/material.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/sound_model.dart';

/// Gradient accent colors per category so each card has a unique identity.
const _categoryGradients = <SoundCategory, List<Color>>{
  SoundCategory.nature: [Color(0xFF2D5A3D), Color(0xFF1A3A2A)],
  SoundCategory.rain: [Color(0xFF1A2D5A), Color(0xFF0F1E3A)],
  SoundCategory.thunder: [Color(0xFF1E1A40), Color(0xFF0F0D2A)],
  SoundCategory.whiteNoise: [Color(0xFF3A2D5A), Color(0xFF251A3A)],
  SoundCategory.urban: [Color(0xFF3A2A1A), Color(0xFF251A0F)],
};

const _categoryIcons = <SoundCategory, IconData>{
  SoundCategory.nature: Icons.forest_rounded,
  SoundCategory.rain: Icons.water_drop_rounded,
  SoundCategory.thunder: Icons.bolt_rounded,
  SoundCategory.whiteNoise: Icons.blur_on_rounded,
  SoundCategory.urban: Icons.location_city_rounded,
};

class SoundCard extends StatelessWidget {
  const SoundCard({
    super.key,
    required this.sound,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final SoundItem sound;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        _categoryGradients[sound.category] ?? [AppColors.surfaceElevated, AppColors.surfaceVariant];
    final icon = _categoryIcons[sound.category] ?? Icons.music_note_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: DesignTokens.borderRadiusLg,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: DesignTokens.shadowMd,
        ),
        child: Stack(
          children: [
            // ── Decorative icon watermark ──────────────────────────────────
            Positioned(
              right: -8,
              bottom: -8,
              child: Icon(
                icon,
                size: 90,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),

            // ── Content ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: DesignTokens.borderRadiusMd,
                    ),
                    child: Icon(icon, size: 20, color: AppColors.primary),
                  ),

                  const Spacer(),

                  // Sound name
                  Text(
                    sound.name,
                    style: AppTypography.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: DesignTokens.spacing1),

                  // Category label
                  Text(
                    _categoryLabel(sound.category),
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
            ),

            // ── Favorite button ────────────────────────────────────────────
            Positioned(
              top: DesignTokens.spacing2,
              right: DesignTokens.spacing2,
              child: _FavoriteButton(
                isFavorite: isFavorite,
                onTap: onFavoriteTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _categoryLabel(SoundCategory cat) {
    return switch (cat) {
      SoundCategory.nature => 'Nature',
      SoundCategory.rain => 'Rain',
      SoundCategory.thunder => 'Thunder',
      SoundCategory.whiteNoise => 'White Noise',
      SoundCategory.urban => 'Urban',
    };
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.30),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: DesignTokens.durationFast,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            size: 16,
            color: isFavorite ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
