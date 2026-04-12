import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/models/library_model.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/providers/library_provider.dart';
import 'package:lull/shared/widgets/glass_container.dart';
import 'package:lull/shared/widgets/save_to_library_button.dart';
import 'package:lull/shared/widgets/scaffold.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(libraryProvider);
    final audioState = ref.watch(audioProvider);
    final canSave = audioState is! AudioIdle;
    final topPadding = MediaQuery.paddingOf(context).top;

    return MyScaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
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
                        'My Library',
                        style: AppTypography.displaySmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacing3),
                      Text(
                        'Your saved sound presets',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              libraryAsync.when(
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Failed to load library',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return SliverFillRemaining(
                      child: _EmptyLibraryState(canSave: canSave),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacing6,
                    ),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (ctx, idx) =>
                          const SizedBox(height: DesignTokens.spacing3),
                      itemBuilder: (context, index) => _LibraryCard(
                        item: items[index],
                        onTap: () => _loadLibrary(context, ref, items[index]),
                        onDelete: () =>
                            _confirmDelete(context, ref, items[index]),
                      ),
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: DesignTokens.navHeightSpacing + DesignTokens.spacing6,
                ),
              ),
            ],
          ),
          if (canSave)
            Positioned(
              bottom: DesignTokens.navHeightSpacing,
              right: DesignTokens.spacing6,
              child: FloatingActionButton.extended(
                heroTag: 'saveLibraryFab',
                onPressed: () =>
                    SaveToLibraryButton.showSaveDialog(context, ref, audioState),
                icon: const Icon(Icons.bookmark_add_rounded),
                label: const Text('Save Current Mix'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadLibrary(
    BuildContext context,
    WidgetRef ref,
    LibraryItem item,
  ) async {
    await ref.read(libraryProvider.notifier).loadLibrary(item);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing "${item.name}"'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    LibraryItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Preset'),
        content: Text('Remove "${item.name}" from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(libraryProvider.notifier).deleteLibrary(item.id);
    }
  }

}

// ── Library Card ───────────────────────────────────────────────────────────────

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final LibraryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final soundCount = item.sounds.length;
    final date = _formatDate(item.createdAt);

    return GlassContainer(
      borderRadius: DesignTokens.borderRadiusMd,
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignTokens.borderRadiusMd,
        child: Row(
          children: [
            Container(
              width: DesignTokens.spacing10,
              height: DesignTokens.spacing10,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                borderRadius: DesignTokens.borderRadiusSm,
              ),
              child: const Icon(
                Icons.library_music_rounded,
                color: AppColors.primary,
                size: DesignTokens.iconMd,
              ),
            ),
            const SizedBox(width: DesignTokens.spacing4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Row(
                    children: [
                      Text(
                        '$soundCount ${soundCount == 1 ? 'sound' : 'sounds'}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      if (item.timerSeconds != null) ...[
                        Text(
                          '  ·  ',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Icon(
                          Icons.timer_outlined,
                          size: DesignTokens.iconSm,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatTimer(item.timerSeconds!),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      Text(
                        '  ·  $date',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppColors.primary,
                  ),
                  tooltip: 'Load & Play',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    if (m < 60) return '${m}m';
    final h = m ~/ 60;
    final rem = m % 60;
    return rem == 0 ? '${h}h' : '${h}h ${rem}m';
  }
}

// ── Empty State ────────────────────────────────────────────────────────────────

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState({required this.canSave});

  final bool canSave;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_music_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              'No saved presets yet',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing2),
            Text(
              canSave
                  ? 'Tap the button below to save your current mix'
                  : 'Play some sounds and save your mix here',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
