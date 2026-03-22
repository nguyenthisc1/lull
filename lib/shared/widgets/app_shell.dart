import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lull/core/router/app_routes.dart';
import 'package:lull/l10n/app_localizations.dart';
import 'package:lull/shared/widgets/navbar.dart';

/// Root shell for the [StatefulShellRoute].
///
/// Stacks the glass [NavBar] over the active tab screen so it truly floats
/// above content — avoiding nested-Scaffold safe-area conflicts.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final tabs = [
      TabItem(
        path: AppRoutes.discover,
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore_rounded,
        label: l10n.navDiscover,
      ),
      TabItem(
        path: AppRoutes.player,
        icon: Icons.play_circle_outline,
        activeIcon: Icons.play_circle_rounded,
        label: l10n.navPlayer,
      ),
      TabItem(
        path: AppRoutes.sound,
        icon: Icons.music_note_outlined,
        activeIcon: Icons.music_note,
        label: l10n.navSound,
      ),
      TabItem(
        path: AppRoutes.library,
        icon: Icons.library_music_outlined,
        activeIcon: Icons.library_music_rounded,
        label: l10n.navLibrary,
      ),

      TabItem(
        path: AppRoutes.settings,
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        label: l10n.navSettings,
      ),
    ];

    return Stack(
      children: [
        navigationShell,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: NavBar(
            currentIndex: navigationShell.currentIndex,
            tabs: tabs,
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ),
      ],
    );
  }
}
