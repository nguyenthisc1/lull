import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Lull'**
  String get appName;

  /// App tagline shown on splash / onboarding
  ///
  /// In en, this message translates to:
  /// **'Sleep sounds for restful nights'**
  String get appTagline;

  /// Splash screen app wordmark, all caps.
  ///
  /// In en, this message translates to:
  /// **'LULL'**
  String get splashWordmark;

  /// Label for showing all sound categories
  ///
  /// In en, this message translates to:
  /// **'All Sounds'**
  String get soundCategoryAll;

  /// Label for Nature sound category
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get soundCategoryNature;

  /// Label for Rain sound category
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get soundCategoryRain;

  /// Label for Thunder sound category
  ///
  /// In en, this message translates to:
  /// **'Thunder'**
  String get soundCategoryThunder;

  /// Label for White Noise sound category
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get soundCategoryWhiteNoise;

  /// Label for Urban sound category
  ///
  /// In en, this message translates to:
  /// **'Urban'**
  String get soundCategoryUrban;

  /// Header/title for the sound library screen
  ///
  /// In en, this message translates to:
  /// **'Sound Library'**
  String get soundLibraryTitle;

  /// Subtitle for the sound library screen describing its purpose
  ///
  /// In en, this message translates to:
  /// **'Mix and match nature sounds to find your calm'**
  String get soundLibrarySubtitle;

  /// Splash screen large app headline, displayed in gradient text.
  ///
  /// In en, this message translates to:
  /// **'Lull'**
  String get splashDisplayHeadline;

  /// Splash screen supporting tagline under logo.
  ///
  /// In en, this message translates to:
  /// **'The Science of Softness'**
  String get splashTagline;

  /// CTA button text for entering the app from splash screen.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get splashGetStarted;

  /// Motivational text shown at the bottom of the splash screen.
  ///
  /// In en, this message translates to:
  /// **'STEP INTO THE QUIET'**
  String get splashStepIntoTheQuiet;

  /// Bottom nav label for Discover / Home tab
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// Bottom nav label for Player tab
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get navPlayer;

  /// Bottom nav label for Library tab
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// Bottom nav label for Sound tab
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get navSound;

  /// Bottom nav label for Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Bottom nav label for Home (legacy)
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav label for Favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// Bottom nav label for Sleep Timer
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get navTimer;

  /// Evening greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get homeGreetingNight;

  /// Subtitle below greeting; matches 'Gợi ý cho bạn'
  ///
  /// In en, this message translates to:
  /// **'Suggestions for you'**
  String get homeSubtitle;

  /// Main home title part 1; matches 'Khám Phá'
  ///
  /// In en, this message translates to:
  /// **'Discover\n'**
  String get homeTitleMain;

  /// Main home title part 2, in accent color; matches 'Sự Bình Yên'
  ///
  /// In en, this message translates to:
  /// **'Serenity'**
  String get homeTitlePrimary;

  /// Home rain card title, matches: 'Tiếng mưa'
  ///
  /// In en, this message translates to:
  /// **'Rain Sounds'**
  String get homeRainTitle;

  /// Home rain card description, matches: 'Âm thanh mưa thư giãn'
  ///
  /// In en, this message translates to:
  /// **'Relaxing rain, storms, and drizzle for restful sleep'**
  String get homeRainDescription;

  /// Home nature card title, matches: 'Thiên nhiên'
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get homeNatureTitle;

  /// Home nature card description, matches: 'Âm thanh thiên nhiên thư giãn'
  ///
  /// In en, this message translates to:
  /// **'Calming forests, rivers, ocean waves & birdsong'**
  String get homeNatureDescription;

  /// Home white noise card title, matches: 'Tiếng ồn trắng'
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get homeWhiteNoiseTitle;

  /// Home white noise card description, matches: 'Âm thanh ồn trắng giúp ngủ hoặc tập trung'
  ///
  /// In en, this message translates to:
  /// **'Pure white, pink & brown noise for deep focus or sleep'**
  String get homeWhiteNoiseDescription;

  /// Home thunder card title, matches: 'Sấm sét'
  ///
  /// In en, this message translates to:
  /// **'Thunder'**
  String get homeThunderTitle;

  /// Home thunder card description, matches: 'Âm thanh sấm sét và mưa đêm'
  ///
  /// In en, this message translates to:
  /// **'Distant rumbles, thunderstorms & night rain'**
  String get homeThunderDescription;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search sounds…'**
  String get homeSearchHint;

  /// Label above track title in player
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get playerNowPlaying;

  /// Slider label for volume
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get playerVolume;

  /// Slider label for intensity
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get playerIntensity;

  /// Loop toggle label
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get playerLoop;

  /// Accessibility label: heart button off
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get playerAddToFavorites;

  /// Accessibility label: heart button on
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get playerRemoveFromFavorites;

  /// Screen title for timer
  ///
  /// In en, this message translates to:
  /// **'Sleep Timer'**
  String get timerTitle;

  /// Button to confirm timer selection
  ///
  /// In en, this message translates to:
  /// **'Set Timer'**
  String get timerSetTimer;

  /// Status when no timer is active
  ///
  /// In en, this message translates to:
  /// **'No timer set'**
  String get timerNoTimer;

  /// Status when timer is counting down
  ///
  /// In en, this message translates to:
  /// **'Timer active'**
  String get timerActive;

  /// Countdown label
  ///
  /// In en, this message translates to:
  /// **'{time} remaining'**
  String timerTimeRemaining(String time);

  /// Quick-select preset: 15 minutes
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get timer15min;

  /// Quick-select preset: 30 minutes
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get timer30min;

  /// Quick-select preset: 1 hour
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get timer60min;

  /// Quick-select preset: 90 minutes
  ///
  /// In en, this message translates to:
  /// **'90 min'**
  String get timer90min;

  /// Custom duration option label
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get timerCustom;

  /// Stop button on active timer
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get timerStop;

  /// Toggle label: fade audio before timer ends
  ///
  /// In en, this message translates to:
  /// **'Fade out audio'**
  String get timerFadeOut;

  /// Screen title for favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// Empty state heading
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmpty;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any sound to save it here'**
  String get favoritesEmptySubtitle;

  /// Screen title for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section header
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// Settings section header
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get settingsSectionPlayback;

  /// Setting row label for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Language option: English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Language option: Vietnamese
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get settingsLanguageVietnamese;

  /// Setting row label for default timer duration
  ///
  /// In en, this message translates to:
  /// **'Default Timer'**
  String get settingsDefaultTimer;

  /// Toggle label for auto-play preference
  ///
  /// In en, this message translates to:
  /// **'Auto-play on open'**
  String get settingsAutoPlay;

  /// Generic OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Generic Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Generic Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// Generic Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Generic Close button / tooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Accessibility label for play button
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get commonPlay;

  /// Accessibility label for pause button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get commonPause;

  /// Pluralised minutes label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} minute} other{{count} minutes}}'**
  String commonMinutes(int count);

  /// Pluralised hours label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} hour} other{{count} hours}}'**
  String commonHours(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
