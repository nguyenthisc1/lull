import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/onboarding_storage.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import 'app_routes.dart';

// ── Onboarding state ─────────────────────────────────────────────────────────

/// Resolves whether the user has already completed onboarding.
/// Loaded once at startup; cached for the lifetime of the ProviderContainer.
final hasSeenSplashProvider = FutureProvider<bool>((ref) {
  return OnboardingStorage.hasSeenSplash();
});

// ── Router provider ───────────────────────────────────────────────────────────

/// Top-level GoRouter instance, rebuilt whenever [hasSeenSplashProvider]
/// changes (i.e. only once, after the async read on first launch).
final routerProvider = Provider<GoRouter>((ref) {
  final hasSeenSplashAsync = ref.watch(hasSeenSplashProvider);

  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: AppRoutes.root,

    // Redirect / → splash or home based on onboarding state.
    redirect: (BuildContext context, GoRouterState state) {
      if (state.matchedLocation != AppRoutes.root) return null;

      return hasSeenSplashAsync.when(
        data: (seen) => seen ? AppRoutes.home : AppRoutes.splash,
        // Show splash while loading (resolves in <1 frame from disk cache).
        loading: () => AppRoutes.splash,
        error: (_, _) => AppRoutes.home,
      );
    },

    routes: [
      GoRoute(
        path: AppRoutes.root,
        // Never rendered — redirect always fires before this builder.
        builder: (_, _) => const SizedBox.shrink(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (_, _) => const HomeScreen(),
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (_, animation, _, child) => FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      ),
    ],
  );
});
