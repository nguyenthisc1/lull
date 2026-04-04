import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/providers/sound_provider.dart';
import 'package:lull/shared/utils/utils.dart';
import 'package:lull/shared/widgets/player_button.dart';

class SoundList extends ConsumerWidget {
  const SoundList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundState = ref.watch(soundProvider);

    if (soundState is SoundLoading || soundState is SoundInitial) {
      return const _SoundListSkeleton();
    }

    if (soundState is SoundError) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacing3),
          child: Text('Error loading sounds: ${soundState.errorMessage}'),
        ),
      );
    }

    if (soundState is SoundLoaded) {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.spacing6,
          DesignTokens.spacing5,
          DesignTokens.spacing6,
          DesignTokens.spacing3,
        ),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: soundState.sounds
                .map<Widget>((sound) => _SoundListItem(sound: sound))
                .toList(),
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

// ── Item ──────────────────────────────────────────────────────────────────────

/// Each item is its own [ConsumerWidget] so only the affected sound rebuilds.
class _SoundListItem extends ConsumerWidget {
  const _SoundListItem({required this.sound});

  final SoundItem sound;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = colorForCategory(sound);
    final notifier = ref.read(audioProvider.notifier);

    // True when this sound is the active single OR is playing in the mix.
    final isPlaying = ref.watch(
      audioProvider.select((s) {
        if (s is AudioMixing) {
          return s.mixerSounds[sound.id]?.playbackState ==
              PlaybackState.playing;
        }
        return s.currentSingle?.sound.id == sound.id &&
            s.currentSingle?.playbackState == PlaybackState.playing;
      }),
    );

    final isInMix = ref.watch(
      audioProvider.select(
        (s) => s is AudioMixing && s.mixerSounds.containsKey(sound.id),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        color: isInMix
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.primaryContainer.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isInMix ? 0.25 : 0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing5,
        vertical: DesignTokens.spacing5,
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Icon(
              iconForCategory(sound),
              size: DesignTokens.iconLg,
              color: color,
            ),
          ),

          // Name + category
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing3,
              ),
              child: Column(
                children: [
                  Text(
                    sound.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    sound.category.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.25,
                      color: AppColors.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Play button — always plays in single mode.
          PlayerButton(
            isPlaying: isPlaying,
            onTogglePlay: () => notifier.playSingle(sound),
            glowAlpha: 0,
            size: DesignTokens.iconXl,
            iconSize: DesignTokens.iconMd,
          ),

          const SizedBox(width: DesignTokens.spacing1),

          // Context menu
          _SoundMenu(sound: sound, isInMix: isInMix, notifier: notifier),
        ],
      ),
    );
  }
}

// ── Context menu ──────────────────────────────────────────────────────────────

class _SoundMenu extends StatelessWidget {
  const _SoundMenu({
    required this.sound,
    required this.isInMix,
    required this.notifier,
  });

  final SoundItem sound;
  final bool isInMix;
  final AudioNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(-DesignTokens.spacing5, 0),
      builder: (context, controller, _) => IconButton(
        icon: const Icon(Icons.more_vert_rounded, size: DesignTokens.iconLg),
        splashRadius: DesignTokens.radiusLg,
        onPressed: controller.open,
      ),
      menuChildren: [
        if (!isInMix)
          MenuItemButton(
            leadingIcon: const Icon(Icons.queue_music_rounded),
            onPressed: () => notifier.addToMix(sound),
            child: const Text('Add to Mix'),
          )
        else
          MenuItemButton(
            leadingIcon: const Icon(Icons.remove_circle_outline_rounded),
            onPressed: () => notifier.removeFromMix(sound),
            child: const Text('Remove from Mix'),
          ),
      ],
    );
  }
}

// ── Skeleton loader ───────────────────────────────────────────────────────────

class _SoundListSkeleton extends StatefulWidget {
  const _SoundListSkeleton();

  @override
  State<_SoundListSkeleton> createState() => _SoundListSkeletonState();
}

class _SoundListSkeletonState extends State<_SoundListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacing6,
        DesignTokens.spacing5,
        DesignTokens.spacing6,
        DesignTokens.spacing3,
      ),
      sliver: SliverToBoxAdapter(
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Column(
            children: List.generate(
              5,
              (_) => _SkeletonItem(pulse: _anim.value),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  const _SkeletonItem({required this.pulse});

  final double pulse;

  Color get _fill => Color.lerp(
    AppColors.outline.withValues(alpha: 0.07),
    AppColors.outline.withValues(alpha: 0.16),
    pulse,
  )!;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing5,
        vertical: DesignTokens.spacing5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        color: _fill,
      ),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: DesignTokens.iconXl + DesignTokens.spacing4 * 2,
            height: DesignTokens.iconXl + DesignTokens.spacing4 * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              color: _fill,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),

          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXs),
                    color: AppColors.outline.withValues(
                      alpha: 0.18 * pulse + 0.07,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing2),
                Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXs),
                    color: AppColors.outline.withValues(
                      alpha: 0.12 * pulse + 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: DesignTokens.spacing3),

          // Button placeholder
          Container(
            width: DesignTokens.iconXl,
            height: DesignTokens.iconXl,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _fill),
          ),
          const SizedBox(width: DesignTokens.spacing2),
          Container(
            width: DesignTokens.iconMd,
            height: DesignTokens.iconMd,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _fill),
          ),
        ],
      ),
    );
  }
}
