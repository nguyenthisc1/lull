import 'package:flutter/widgets.dart';
import 'package:lull/core/theme/app_colors.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
    required this.color,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: filled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                )
              : null,
          color: filled ? null : AppColors.surfaceVariant,
          border: filled
              ? null
              : Border.all(
                  color: AppColors.outline.withValues(alpha: 0.60),
                  width: 1,
                ),
        ),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}
