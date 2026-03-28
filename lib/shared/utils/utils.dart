import 'package:flutter/material.dart';
import 'package:lull/l10n/app_localizations.dart';
import 'package:lull/models/sound_model.dart';

IconData iconForCategory(SoundItem sound) {
  switch (sound.iconName) {
    // Nature
    case 'yard':
      return Icons.eco_rounded;
    case 'water':
      return Icons.water_drop_rounded;
    case 'forest':
      return Icons.park_rounded;
    case 'flutter_dash':
      return Icons.flight_rounded;
    case 'air':
      return Icons.air_rounded;
    case 'water_drop':
      return Icons.water_drop_outlined;
    case 'nights_stay':
      return Icons.nights_stay_rounded;
    case 'nightlight':
      return Icons.nightlight_rounded;
    case 'waves':
      return Icons.waves_rounded;

    // Rain / Weather / Urban
    case 'snowing':
      return Icons.cloudy_snowing;
    case 'location_city':
      return Icons.location_city_rounded;
    case 'thunderstorm':
      return Icons.thunderstorm_rounded;
    case 'apartment':
      return Icons.apartment_rounded;
    case 'directions_car':
      return Icons.directions_car_rounded;
    case 'traffic':
      return Icons.traffic_rounded;
    case 'grain':
      return Icons.grain_rounded;
    case 'roofing':
      return Icons.roofing_rounded;

    // Thunder
    case 'bolt':
      return Icons.bolt_rounded;
    case 'cloudy_snowing':
      return Icons.wb_cloudy_outlined;
    case 'flash_on':
      return Icons.flash_on_rounded;

    // Fallbacks & additional
    case 'unknown':
      return Icons.music_note_rounded;
  }

  // Fallback: Use category-based enum mapping, from sound_model.dart line 3
  switch (sound.category) {
    case SoundCategory.nature:
      return Icons.eco_rounded;
    case SoundCategory.rain:
      return Icons.water_drop_rounded;
    case SoundCategory.thunder:
      return Icons.flash_on_rounded;
    case SoundCategory.whiteNoise:
      return Icons.noise_aware_rounded;
    case SoundCategory.urban:
      return Icons.location_city_rounded;
  }
}

Color colorForCategory(SoundItem sound) {
  // Use enum-based color mapping for each SoundCategory as in sound_model.dart (3)
  switch (sound.category) {
    case SoundCategory.nature:
      return const Color(0xFF4CAF50); // Nature green
    case SoundCategory.rain:
      return const Color(0xFF2196F3); // Rain blue
    case SoundCategory.thunder:
      return const Color(
        0xFF9575CD,
      ); // Thunder purple-tint, updated for more distinction
    case SoundCategory.whiteNoise:
      return const Color(0xFFBDBDBD); // Softer white noise grey
    case SoundCategory.urban:
      return const Color(0xFF607D8B); // Urban bluish-grey
  }
}

String categoryLabel(SoundCategory category, AppLocalizations l10n) {
  switch (category) {
    case SoundCategory.nature:
      return l10n.soundCategoryNature;
    case SoundCategory.rain:
      return l10n.soundCategoryRain;
    case SoundCategory.thunder:
      return l10n.soundCategoryThunder;
    case SoundCategory.whiteNoise:
      return l10n.soundCategoryWhiteNoise;
    case SoundCategory.urban:
      return l10n.soundCategoryUrban;
  }
}
