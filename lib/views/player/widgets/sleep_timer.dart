import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';

class SleepTimer extends StatelessWidget {
  const SleepTimer({
    super.key,
    required this.selectedMinutes,
    required this.presets,
    required this.onSelect,
    this.sleepTimeLeft,
  });

  final int selectedMinutes;
  final List<int> presets;
  final ValueChanged<int> onSelect;

  /// When provided, the selected chip shows a live countdown instead of
  /// the static preset label.
  final Duration? sleepTimeLeft;

  String _chipLabel(int min, bool isSelected) {
    if (min == 0) return 'Off';
    if (isSelected && sleepTimeLeft != null && sleepTimeLeft!.inSeconds > 0) {
      final m = sleepTimeLeft!.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = sleepTimeLeft!.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$m.$s';
    }
    return '${min}m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'SLEEP TIMER',
            style: AppTypography.labelSmall.copyWith(
              letterSpacing: 2.5,
              color: AppColors.onSurfaceVariant,
            ),
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
                    _chipLabel(min, selected),
                    textAlign: TextAlign.center,
                    style: AppTypography.labelMedium.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
