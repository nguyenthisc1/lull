import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/onboarding_storage.dart';
import '../../shared/widgets/app_shell.dart';
import '../../views/home/home_screen.dart';
import '../../views/library/library_screen.dart';
import '../../views/player/player_screen.dart';
import '../../views/settings/settings_screen.dart';
import '../../views/splash/splash_screen.dart';
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

    // Redirect / → splash or discover based on onboarding state.
    redirect: (BuildContext context, GoRouterState state) {
      if (state.matchedLocation != AppRoutes.root) return null;

      return hasSeenSplashAsync.when(
        data: (seen) => seen ? AppRoutes.discover : AppRoutes.splash,
        // Show splash while loading (resolves in <1 frame from disk cache).
        loading: () => AppRoutes.splash,
        error: (_, _) => AppRoutes.discover,
      );
    },

    routes: [
      // ── Root placeholder ─────────────────────────────────────────────────
      GoRoute(path: AppRoutes.root, builder: (_, _) => const SizedBox.shrink()),

      // ── Onboarding ───────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (_, animation, _, child) => FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),

      // ── Main shell (Discover · Player · Library · Settings) ───────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Tab 0 – Discover
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                name: 'discover',
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),

          // Tab 1 – Player
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.player,
                name: 'player',
                builder: (_, _) => const PlayerScreen(),
              ),
            ],
          ),

          // Tab 2 – Library
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                name: 'library',
                builder: (_, _) => const LibraryScreen(),
              ),
            ],
          ),

          // Tab 3 – Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
