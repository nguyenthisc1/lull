import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key, required this.locale, required this.onTap});

  final Locale locale;
  final VoidCallback onTap;

  static const Map<String, String> _langs = {'en': 'English', 'vi': 'Tiếng Việt'};

  @override
  Widget build(BuildContext context) {
    final String code =
        _langs[locale.languageCode] ?? locale.languageCode.toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: DesignTokens.durationFast,
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: ClipRRect(
          key: ValueKey(locale.languageCode),
          borderRadius: DesignTokens.borderRadiusChip,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing3,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.50),
                borderRadius: DesignTokens.borderRadiusChip,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    code,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
