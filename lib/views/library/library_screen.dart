import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/router/app_routes.dart';
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
                loading: () => const SliverToBoxAdapter(
                  child: _LibrarySkeleton(),
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
      context.go(AppRoutes.sound);
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

// ── Skeleton Loading ───────────────────────────────────────────────────────────

class _LibrarySkeleton extends StatefulWidget {
  const _LibrarySkeleton();

  @override
  State<_LibrarySkeleton> createState() => _LibrarySkeletonState();
}

class _LibrarySkeletonState extends State<_LibrarySkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing6,
        ),
        child: Column(
          children: List.generate(
            4,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
              child: _buildSkeletonCard(_opacity.value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard(double opacity) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: opacity),
        borderRadius: DesignTokens.borderRadiusMd,
      ),
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      child: Row(
        children: [
          Container(
            width: DesignTokens.spacing10,
            height: DesignTokens.spacing10,
            decoration: BoxDecoration(
              color: AppColors.outline.withValues(alpha: opacity * 0.7),
              borderRadius: DesignTokens.borderRadiusSm,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: opacity * 0.7),
                    borderRadius: DesignTokens.borderRadiusChip,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing2),
                Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: opacity * 0.45),
                    borderRadius: DesignTokens.borderRadiusChip,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.outline.withValues(alpha: opacity * 0.5),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
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
