import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.blur = DesignTokens.glassBlur,
    this.opacity = DesignTokens.glassOpacity,
    this.border = true,
    this.width,
    this.height,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final bool border;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? DesignTokens.borderRadiusLg;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: border
            ? Border.all(color: AppColors.glassBorder, width: 1)
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: opacity),
              borderRadius: radius,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
