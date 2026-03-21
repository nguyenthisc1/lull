import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lull/l10n/app_localizations.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../repositories/onboarding_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final AnimationController _shimmerController;

  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _moonScale;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _fadeIn = CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _enterController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _moonScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
    _shimmerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    await OnboardingStorage.markSplashSeen();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Gradient background ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0D1A),
                  Color(0xFF12102B),
                  Color(0xFF0D1020),
                ],
              ),
            ),
          ),

          // ── Starry sky texture ──────────────────────────────────────────
          CustomPaint(size: size, painter: _StarryPainter()),

          // ── Bottom-left ambient orb ─────────────────────────────────────
          Positioned(
            bottom: -size.height * 0.25,
            left: -size.width * 0.25,
            child: _AmbientOrb(
              size: size.width * 0.9,
              color: AppColors.primary,
              opacity: 0.05,
              blur: 120,
            ),
          ),

          // ── Top-right ambient orb ───────────────────────────────────────
          Positioned(
            top: -size.height * 0.15,
            right: -size.width * 0.2,
            child: _AmbientOrb(
              size: size.width * 0.7,
              color: AppColors.secondary,
              opacity: 0.05,
              blur: 100,
            ),
          ),

          // ── Celestial radial glow (centered) ───────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [Color(0x1FCEB1FF), Color(0x000D0D1A)],
                ),
              ),
            ),
          ),

          // ── Main content ────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  children: [
                    // Top wordmark row
                    Padding(
                      padding: const EdgeInsets.only(
                        top: DesignTokens.spacing5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nights_stay,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: DesignTokens.spacing2),
                          Text(
                            l10n.splashDisplayHeadline,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expanded center area
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── Moon icon with glow ring ──────────────────
                          ScaleTransition(
                            scale: _moonScale,
                            child: AnimatedBuilder(
                              animation: _glowPulse,
                              builder: (context, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer glow halo
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.20,
                                          ),
                                          width: 1.5,
                                        ),
                                        gradient: RadialGradient(
                                          colors: [
                                            AppColors.primary.withValues(
                                              alpha: 0.06 * _glowPulse.value,
                                            ),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Inner frosted circle
                                    ClipOval(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 4,
                                          sigmaY: 4,
                                        ),
                                        child: Container(
                                          width: 192,
                                          height: 192,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary.withValues(
                                              alpha: 0.05,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Moon icon with glow
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: AppColors.primaryGradient,
                                          ).createShader(bounds),
                                      child: Icon(
                                        Icons.dark_mode_rounded,
                                        size: 88,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: DesignTokens.spacing8),

                          // ── Display headline ──────────────────────────
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFE8DAFF), Color(0xFFCEB1FF)],
                            ).createShader(bounds),
                            child: Text(
                              l10n.splashDisplayHeadline,
                              style: AppTypography.displayLarge.copyWith(
                                fontSize: 72,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),

                          const SizedBox(height: DesignTokens.spacing3),

                          // ── Tagline ───────────────────────────────────
                          Text(
                            l10n.splashTagline,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.60,
                              ),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom CTA area ─────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: bottom + DesignTokens.spacing8,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacing6,
                    ),
                    child: _GetStartedButton(onTap: _onGetStarted),
                  ),
                  const SizedBox(height: DesignTokens.spacing5),
                  Text(
                    l10n.splashStepIntoTheQuiet,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.35),
                      letterSpacing: 4,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Get Started button (glassmorphic) ────────────────────────────────────────

class _GetStartedButton extends StatefulWidget {
  const _GetStartedButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
    _glowOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) {
        _hoverController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _hoverController.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: _glowOpacity,
          builder: (context, child) => Stack(
            children: [
              // Glass button body
              ClipRRect(
                borderRadius: DesignTokens.borderRadiusLg,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0x1A23233C),
                      borderRadius: DesignTokens.borderRadiusLg,
                      border: Border.all(
                        color: AppColors.outline.withValues(alpha: 0.20),
                        width: 1,
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),

              // Hover gradient overlay
              Positioned.fill(
                child: Opacity(
                  opacity: _glowOpacity.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: DesignTokens.borderRadiusLg,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.20),
                          AppColors.primaryContainer.withValues(alpha: 0.20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom glow line
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 160,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withValues(
                            alpha: 0.40 * _glowOpacity.value,
                          ),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.splashGetStarted,
                  style: AppTypography.titleSmall.copyWith(letterSpacing: 0.5),
                ),
                const SizedBox(width: DesignTokens.spacing3),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Ambient orb widget ────────────────────────────────────────────────────────

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({
    required this.size,
    required this.color,
    required this.opacity,
    required this.blur,
  });

  final double size;
  final Color color;
  final double opacity;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

// ── Starry sky painter ────────────────────────────────────────────────────────

class _StarryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint();

    for (var i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = rng.nextDouble() * 1.2 + 0.3;
      final opacity = rng.nextDouble() * 0.12 + 0.03;

      // Alternate between white and soft purple stars
      final color = rng.nextBool()
          ? const Color(0xFFE5E3FF)
          : const Color(0xFFCEB1FF);

      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
