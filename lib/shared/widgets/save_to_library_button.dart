import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/providers/library_provider.dart';

/// A button that opens a bottom-sheet dialog to save the current mix
/// as a named preset in the library. Only visible when audio is not idle.
class SaveToLibraryButton extends ConsumerWidget {
  const SaveToLibraryButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    if (audioState is AudioIdle) return const SizedBox.shrink();

    return Center(
      child: TextButton.icon(
        onPressed: () => showSaveDialog(context, ref, audioState),
        icon: const Icon(Icons.bookmark_add_outlined, size: DesignTokens.iconMd),
        label: const Text('Save to Library'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
    );
  }

  static Future<void> showSaveDialog(
    BuildContext context,
    WidgetRef ref,
    AudioState audioState,
  ) async {
    final mode = ref.read(audioModeProvider);

    // The sheet owns its own controller — no external dispose needed.
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusXl),
        ),
      ),
      builder: (ctx) => const _SaveLibrarySheet(),
    );

    if (result != null && result.trim().isNotEmpty && context.mounted) {
      await ref.read(libraryProvider.notifier).addLibrary(
        name: result.trim(),
        audioState: audioState,
        mode: mode,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved "${result.trim()}" to library'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

// ── Save Library Bottom Sheet ──────────────────────────────────────────────────

class _SaveLibrarySheet extends StatefulWidget {
  const _SaveLibrarySheet();

  @override
  State<_SaveLibrarySheet> createState() => _SaveLibrarySheetState();
}

class _SaveLibrarySheetState extends State<_SaveLibrarySheet> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() => _hasText = _controller.text.trim().isNotEmpty);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        DesignTokens.spacing6,
        DesignTokens.spacing6,
        DesignTokens.spacing6,
        DesignTokens.spacing6 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: DesignTokens.borderRadiusChip,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing5),
          Text(
            'Save to Library',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            'Give your current mix a name to save it for later.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing5),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g. Rainy Night Mix',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: DesignTokens.borderRadiusMd,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing4,
                vertical: DesignTokens.spacing4,
              ),
            ),
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) Navigator.of(context).pop(v);
            },
          ),
          const SizedBox(height: DesignTokens.spacing5),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _hasText
                  ? () => Navigator.of(context).pop(_controller.text)
                  : null,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
