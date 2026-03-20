import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale';

const supportedLocales = [
  Locale('en'),
  Locale('vi'),
];

class LocaleNotifier extends Notifier<Locale> {
  static const _defaultLocale = Locale('en');

  @override
  Locale build() => _defaultLocale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) {
      final locale = supportedLocales.firstWhere(
        (l) => l.languageCode == saved,
        orElse: () => _defaultLocale,
      );
      state = locale;
    }
  }

  Future<void> setLocale(Locale locale) async {
    assert(
      supportedLocales.contains(locale),
      'Locale $locale is not in supportedLocales',
    );
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    final next = state.languageCode == 'en' ? const Locale('vi') : const Locale('en');
    await setLocale(next);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
