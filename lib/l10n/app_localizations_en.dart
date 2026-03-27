// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lull';

  @override
  String get appTagline => 'Sleep sounds for restful nights';

  @override
  String get splashWordmark => 'LULL';

  @override
  String get soundCategoryAll => 'All Sounds';

  @override
  String get soundCategoryNature => 'Nature';

  @override
  String get soundCategoryRain => 'Rain';

  @override
  String get soundCategoryThunder => 'Thunder';

  @override
  String get soundCategoryWhiteNoise => 'White Noise';

  @override
  String get soundCategoryUrban => 'Urban';

  @override
  String get soundLibraryTitle => 'Sound Library';

  @override
  String get soundLibrarySubtitle =>
      'Mix and match nature sounds to find your calm';

  @override
  String get splashDisplayHeadline => 'Lull';

  @override
  String get splashTagline => 'The Science of Softness';

  @override
  String get splashGetStarted => 'Get Started';

  @override
  String get splashStepIntoTheQuiet => 'STEP INTO THE QUIET';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navPlayer => 'Player';

  @override
  String get navLibrary => 'Library';

  @override
  String get navSound => 'Sound';

  @override
  String get navSettings => 'Settings';

  @override
  String get navHome => 'Home';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navTimer => 'Timer';

  @override
  String get homeGreetingNight => 'Good night';

  @override
  String get homeSubtitle => 'Suggestions for you';

  @override
  String get homeTitleMain => 'Discover\n';

  @override
  String get homeTitlePrimary => 'Serenity';

  @override
  String get homeRainTitle => 'Rain Sounds';

  @override
  String get homeRainDescription =>
      'Relaxing rain, storms, and drizzle for restful sleep';

  @override
  String get homeNatureTitle => 'Nature';

  @override
  String get homeNatureDescription =>
      'Calming forests, rivers, ocean waves & birdsong';

  @override
  String get homeWhiteNoiseTitle => 'White Noise';

  @override
  String get homeWhiteNoiseDescription =>
      'Pure white, pink & brown noise for deep focus or sleep';

  @override
  String get homeThunderTitle => 'Thunder';

  @override
  String get homeThunderDescription =>
      'Distant rumbles, thunderstorms & night rain';

  @override
  String get homeSearchHint => 'Search sounds…';

  @override
  String get playerNowPlaying => 'Now Playing';

  @override
  String get playerVolume => 'Volume';

  @override
  String get playerIntensity => 'Intensity';

  @override
  String get playerLoop => 'Loop';

  @override
  String get playerAddToFavorites => 'Add to Favorites';

  @override
  String get playerRemoveFromFavorites => 'Remove from Favorites';

  @override
  String get timerTitle => 'Sleep Timer';

  @override
  String get timerSetTimer => 'Set Timer';

  @override
  String get timerNoTimer => 'No timer set';

  @override
  String get timerActive => 'Timer active';

  @override
  String timerTimeRemaining(String time) {
    return '$time remaining';
  }

  @override
  String get timer15min => '15 min';

  @override
  String get timer30min => '30 min';

  @override
  String get timer60min => '1 hour';

  @override
  String get timer90min => '90 min';

  @override
  String get timerCustom => 'Custom';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerFadeOut => 'Fade out audio';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get favoritesEmptySubtitle =>
      'Tap the heart on any sound to save it here';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionPlayback => 'Playback';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsDefaultTimer => 'Default Timer';

  @override
  String get settingsAutoPlay => 'Auto-play on open';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDone => 'Done';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonPlay => 'Play';

  @override
  String get commonPause => 'Pause';

  @override
  String commonMinutes(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString minutes',
      one: '$countString minute',
    );
    return '$_temp0';
  }

  @override
  String commonHours(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString hours',
      one: '$countString hour',
    );
    return '$_temp0';
  }
}
