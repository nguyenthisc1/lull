// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Lull';

  @override
  String get appTagline => 'Âm thanh ru ngủ cho những đêm ngon giấc';

  @override
  String get splashWordmark => 'LULL';

  @override
  String get splashDisplayHeadline => 'Lull';

  @override
  String get splashTagline => 'Khoa học về sự êm dịu';

  @override
  String get splashGetStarted => 'Bắt đầu';

  @override
  String get splashStepIntoTheQuiet => 'BƯỚC VÀO YÊN LẶNG';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navFavorites => 'Yêu thích';

  @override
  String get navTimer => 'Hẹn giờ';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get homeGreetingNight => 'Chúc ngủ ngon';

  @override
  String get homeSubtitle => 'Gợi ý cho bạn';

  @override
  String get homeTitleMain => 'Khám Phá\n';

  @override
  String get homeTitlePrimary => 'Sự Bình Yên';

  @override
  String get homeRainTitle => 'Tiếng mưa';

  @override
  String get homeRainDescription => 'Âm thanh mưa thư giãn cho giấc ngủ ngon';

  @override
  String get homeNatureTitle => 'Thiên nhiên';

  @override
  String get homeNatureDescription =>
      'Âm thanh thiên nhiên thư giãn — rừng, sông, biển & chim hót';

  @override
  String get homeWhiteNoiseTitle => 'Tiếng ồn trắng';

  @override
  String get homeWhiteNoiseDescription =>
      'Tiếng ồn trắng, hồng & nâu giúp ngủ sâu hoặc tập trung';

  @override
  String get homeThunderTitle => 'Sấm sét';

  @override
  String get homeThunderDescription =>
      'Âm thanh sấm sét xa, mưa đêm và dông bão';

  @override
  String get homeSearchHint => 'Tìm âm thanh…';

  @override
  String get playerNowPlaying => 'Đang phát';

  @override
  String get playerVolume => 'Âm lượng';

  @override
  String get playerIntensity => 'Cường độ';

  @override
  String get playerLoop => 'Lặp lại';

  @override
  String get playerAddToFavorites => 'Thêm vào yêu thích';

  @override
  String get playerRemoveFromFavorites => 'Xóa khỏi yêu thích';

  @override
  String get timerTitle => 'Hẹn giờ ngủ';

  @override
  String get timerSetTimer => 'Đặt hẹn giờ';

  @override
  String get timerNoTimer => 'Chưa đặt hẹn giờ';

  @override
  String get timerActive => 'Đang đếm ngược';

  @override
  String timerTimeRemaining(String time) {
    return 'Còn lại $time';
  }

  @override
  String get timer15min => '15 phút';

  @override
  String get timer30min => '30 phút';

  @override
  String get timer60min => '1 giờ';

  @override
  String get timer90min => '90 phút';

  @override
  String get timerCustom => 'Tuỳ chỉnh';

  @override
  String get timerStop => 'Dừng';

  @override
  String get timerFadeOut => 'Giảm dần âm thanh';

  @override
  String get favoritesTitle => 'Yêu thích';

  @override
  String get favoritesEmpty => 'Chưa có yêu thích nào';

  @override
  String get favoritesEmptySubtitle =>
      'Nhấn trái tim trên bất kỳ âm thanh nào để lưu tại đây';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsSectionGeneral => 'Chung';

  @override
  String get settingsSectionPlayback => 'Phát lại';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsDefaultTimer => 'Hẹn giờ mặc định';

  @override
  String get settingsAutoPlay => 'Tự phát khi mở ứng dụng';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Huỷ';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonPlay => 'Phát';

  @override
  String get commonPause => 'Tạm dừng';

  @override
  String commonMinutes(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString phút',
      one: '$countString phút',
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
      other: '$countString giờ',
      one: '$countString giờ',
    );
    return '$_temp0';
  }
}
