import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/shared/l10n/app_localizations.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/sound_provider.dart';
import 'package:lull/shared/utils/utils.dart';

class SoundCategoryWidget extends ConsumerWidget {
  const SoundCategoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = SoundCategory.values;

    final soundState = ref.watch(soundProvider);
    SoundCategory? selectedCategory;
    if (soundState is SoundLoaded) {
      selectedCategory = soundState.selectedCategory;
    } else {
      selectedCategory = null;
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacing6,
        DesignTokens.spacing5,
        DesignTokens.spacing6,
        DesignTokens.spacing3,
      ),
      sliver: SliverToBoxAdapter(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(soundProvider.notifier).loadByCategory(null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCategory == null
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.primaryContainer.withAlpha(
                          (0.15 * 255).toInt(),
                        ),
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing6,
                    vertical: DesignTokens.spacing5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  textStyle: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: Text(
                  l10n.soundCategoryAll,
                  style: AppTypography.labelLarge.copyWith(
                    color: selectedCategory == null
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              ...categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: DesignTokens.spacing3),
                  child: ElevatedButton(
                    onPressed: () {
                      // Set the category: delegate to provider's loadByCategory
                      ref.read(soundProvider.notifier).loadByCategory(category);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.primaryContainer.withAlpha(
                              (0.15 * 255).toInt(),
                            ),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing6,
                        vertical: DesignTokens.spacing5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusLg,
                        ),
                      ),
                      textStyle: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(
                      categoryLabel(category, l10n),
                      style: AppTypography.labelLarge.copyWith(
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
