import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const MyAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.nights_stay, color: AppColors.primary, size: 22),
          const SizedBox(width: DesignTokens.spacing2),
          Text(
            'LULL',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary,
              letterSpacing: 6,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (title != null && title!.isNotEmpty) ...[
            const SizedBox(width: 12),
            Text(title!, style: AppTypography.labelLarge),
          ],
        ],
      ),
      actions: actions,
      leading: leading,
      backgroundColor: AppColors.onSecondary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
