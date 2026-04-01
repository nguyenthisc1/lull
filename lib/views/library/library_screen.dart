import 'package:flutter/material.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/shared/l10n/app_localizations.dart';
import 'package:lull/shared/widgets/scaffold.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MyScaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_music_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.40),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.navLibrary,
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
