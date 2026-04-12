import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/audio/audio_provider.dart';
import 'providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: LullApp()));
}

class LullApp extends ConsumerStatefulWidget {
  const LullApp({super.key});

  @override
  ConsumerState<LullApp> createState() => _LullAppState();
}

class _LullAppState extends ConsumerState<LullApp> {
  @override
  void initState() {
    super.initState();
    // Load persisted locale from storage on first frame.
    Future.microtask(() async {
      await ref.read(localeProvider.notifier).init();
      await ref.read(audioProvider.notifier).restoreLastSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Lull',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
