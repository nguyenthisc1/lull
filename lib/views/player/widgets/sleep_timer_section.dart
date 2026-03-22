import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';

class SleepTimerSection extends StatelessWidget {
  const SleepTimerSection({
    super.key,
    required this.selectedMinutes,
    required this.presets,
    required this.onSelect,
  });

  final int selectedMinutes;
  final List<int> presets;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Text(
                'SLEEP TIMER',
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 2.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '$selectedMinutes min',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: presets.map((min) {
            final selected = min == selectedMinutes;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(min),
                child: AnimatedContainer(
                  duration: DesignTokens.durationFast,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.18)
                        : AppColors.surfaceVariant,
                    borderRadius: DesignTokens.borderRadiusMd,
                    border: Border.all(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.60)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${min}m',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelMedium.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
