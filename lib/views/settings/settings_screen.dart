import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/core/theme/app_typography.dart';
import 'package:lull/shared/l10n/app_localizations.dart';
import 'package:lull/providers/locale_provider.dart';
import 'package:lull/shared/widgets/scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return MyScaffold(
      title: l10n.settingsTitle,
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 120, 24, 120),
        children: [
          _SectionHeader(l10n.settingsSectionGeneral),
          _SettingsTile(
            icon: Icons.language_rounded,
            label: l10n.settingsLanguage,
            trailing: Text(
              locale.languageCode == 'vi'
                  ? l10n.settingsLanguageVietnamese
                  : l10n.settingsLanguageEnglish,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            onTap: () => ref.read(localeProvider.notifier).toggleLocale(),
          ),
          const SizedBox(height: 8),
          _SectionHeader(l10n.settingsSectionPlayback),
          _SettingsTile(
            icon: Icons.timer_outlined,
            label: l10n.settingsDefaultTimer,
            trailing: Text(
              l10n.timer30min,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          _SettingsTile(
            icon: Icons.play_arrow_rounded,
            label: l10n.settingsAutoPlay,
            trailing: Switch(
              value: false,
              onChanged: (_) {},
              activeThumbColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: AppTypography.bodyMedium),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
