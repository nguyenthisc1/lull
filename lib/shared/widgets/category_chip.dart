import 'package:flutter/material.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignTokens.durationFast,
        curve: DesignTokens.curveStandard,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing4,
          vertical: DesignTokens.spacing2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.surfaceVariant,
          borderRadius: DesignTokens.borderRadiusChip,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
