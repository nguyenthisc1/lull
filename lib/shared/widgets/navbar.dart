// ── Glass nav bar ─────────────────────────────────────────────────────────────

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  final int currentIndex;
  final List<TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        DesignTokens.spacing4,
        0,
        DesignTokens.spacing4,
        bottomPadding + DesignTokens.spacing3,
      ),
      child: ClipRRect(
        borderRadius: DesignTokens.borderRadiusXl,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.glassBlur,
            sigmaY: DesignTokens.glassBlur,
          ),
          child: Container(
            height: DesignTokens.navHeight,
            padding: EdgeInsets.all(DesignTokens.spacing2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: DesignTokens.borderRadiusXl,
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: List.generate(
                  tabs.length,
                  (i) => Expanded(
                    child: _NavButton(
                      tab: tabs[i],
                      isSelected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Individual nav button ─────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final TabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Set minHeight so contents always fit and avoid RenderFlex overflow
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50.0),
        padding: EdgeInsets.all(DesignTokens.spacing1),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusChip),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevent unnecessary extra height
          children: [
            AnimatedContainer(
              duration: DesignTokens.durationFast,
              curve: DesignTokens.curveStandard,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: DesignTokens.borderRadiusMd,
              ),
              child: Icon(
                isSelected ? tab.activeIcon : tab.icon,
                size: DesignTokens.iconMd,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
            // Label
            AnimatedDefaultTextStyle(
              duration: DesignTokens.durationFast,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab descriptor ────────────────────────────────────────────────────────────

class TabItem {
  const TabItem({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
