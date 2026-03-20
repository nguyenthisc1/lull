import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import '../constants/design_tokens.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // ── Color Scheme ────────────────────────────────────────────────────
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          surface: AppColors.surface,
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondary: AppColors.onSecondary,
          tertiary: AppColors.tertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          error: AppColors.error,
          onError: AppColors.onError,
        ),

        // ── Scaffold / Canvas ────────────────────────────────────────────────
        scaffoldBackgroundColor: AppColors.surface,

        // ── Typography ───────────────────────────────────────────────────────
        textTheme: AppTypography.textTheme,

        // ── AppBar ───────────────────────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.titleLarge,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.surface,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.onSurface,
            size: DesignTokens.iconMd,
          ),
        ),

        // ── Navigation Bar ───────────────────────────────────────────────────
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.glass,
          elevation: 0,
          indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.25),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall
                  .copyWith(color: AppColors.primary);
            }
            return AppTypography.labelSmall;
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.primary,
                size: DesignTokens.iconMd,
              );
            }
            return const IconThemeData(
              color: AppColors.onSurfaceVariant,
              size: DesignTokens.iconMd,
            );
          }),
        ),

        // ── Cards ────────────────────────────────────────────────────────────
        cardTheme: CardTheme(
          color: AppColors.surfaceElevated,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadiusLg,
          ),
        ),

        // ── Chips ────────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primaryContainer.withValues(alpha: 0.30),
          labelStyle: AppTypography.labelMedium,
          side: BorderSide.none,
          shape: const RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadiusChip,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing3,
            vertical: DesignTokens.spacing1,
          ),
        ),

        // ── Buttons ──────────────────────────────────────────────────────────
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            textStyle: AppTypography.labelLarge,
            shape: const RoundedRectangleBorder(
              borderRadius: DesignTokens.borderRadiusChip,
            ),
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing6,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.labelLarge,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: const RoundedRectangleBorder(
              borderRadius: DesignTokens.borderRadiusChip,
            ),
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing6,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.labelLarge,
            shape: const RoundedRectangleBorder(
              borderRadius: DesignTokens.borderRadiusMd,
            ),
          ),
        ),

        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.onSurface,
            highlightColor: AppColors.primary.withValues(alpha: 0.12),
          ),
        ),

        // ── Slider ───────────────────────────────────────────────────────────
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.outline,
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primary.withValues(alpha: 0.15),
          trackHeight: DesignTokens.sliderTrackHeight,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: DesignTokens.sliderThumbRadius,
          ),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        ),

        // ── Bottom Sheet ─────────────────────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceVariant,
          modalBackgroundColor: AppColors.surfaceVariant,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(DesignTokens.radiusLg),
            ),
          ),
        ),

        // ── Dialog ───────────────────────────────────────────────────────────
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.surfaceVariant,
          elevation: 0,
          titleTextStyle: AppTypography.headlineSmall,
          contentTextStyle: AppTypography.bodyMedium,
          shape: const RoundedRectangleBorder(
            borderRadius: DesignTokens.borderRadiusLg,
          ),
        ),

        // ── Input / TextField ────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          hintStyle:
              AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
          labelStyle: AppTypography.bodyMedium,
          border: OutlineInputBorder(
            borderRadius: DesignTokens.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: DesignTokens.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: DesignTokens.borderRadiusMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing4,
            vertical: DesignTokens.spacing3,
          ),
        ),

        // ── Divider ──────────────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          thickness: 0,
          space: 0,
        ),

        // ── Page Transitions ─────────────────────────────────────────────────
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}
