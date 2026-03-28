import 'package:flutter/material.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';

/// Displays either a sleep-timer countdown (`MM.SS`) or an infinity icon
/// when the timer is off.
class SoLoudProgressBar extends StatelessWidget {
  const SoLoudProgressBar({
    super.key,
    this.sleepTimeLeft,
    this.isOff = false,
  });

  /// Remaining sleep time. Null is treated the same as [isOff].
  final Duration? sleepTimeLeft;

  /// When true, shows ∞ instead of a countdown.
  final bool isOff;

  // MM.SS format with dot separator: 30.00 → 29.59 → …
  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m.$s';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isOff || sleepTimeLeft == null
          ? _buildOff()
          : _buildCountdown(),
    );
  }

  Widget _buildCountdown() {
    return Center(
      key: const ValueKey('countdown'),
      child: Text(
        _fmt(sleepTimeLeft!),
        style: AppTypography.displaySmall.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 6,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildOff() {
    return Center(
      key: const ValueKey('off'),
      child: Icon(
        Icons.all_inclusive_rounded,
        size: 44,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
