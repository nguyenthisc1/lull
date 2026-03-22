import 'package:flutter/widgets.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/l10n/app_localizations.dart';

class SoundHeader extends StatelessWidget {
  const SoundHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        DesignTokens.spacing6,
        topPadding + DesignTokens.spacing6,
        DesignTokens.spacing6,
        DesignTokens.spacing5,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.soundLibraryTitle,
              style: AppTypography.displaySmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing3),
            Text(
              l10n.soundLibrarySubtitle,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
