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
  String get appTagline => 'Âm thanh thư giãn cho giấc ngủ ngon';

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
  String get homeSubtitle => 'Chọn âm thanh để đi vào giấc ngủ';

  @override
  String get homeCategoryAll => 'Tất cả';

  @override
  String get homeCategoryNature => 'Thiên nhiên';

  @override
  String get homeCategoryRain => 'Mưa';

  @override
  String get homeCategoryWhiteNoise => 'Tiếng ồn trắng';

  @override
  String get homeCategoryUrban => 'Đô thị';

  @override
  String get homeFeatured => 'Nổi bật';

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
  String get playerRemoveFromFavorites => 'Xoá khỏi yêu thích';

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
  String get favoritesEmpty => 'Chưa có mục yêu thích';

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

    return '$countString phút';
  }

  @override
  String commonHours(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString giờ';
  }
}
