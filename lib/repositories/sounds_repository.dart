import '../models/sound_model.dart';

abstract interface class SoundsRepository {
  Future<List<SoundItem>> getAllSounds();
  Future<List<SoundItem>> getByCategory(SoundCategory category);
}

class LocalSoundsRepository implements SoundsRepository {
  final List<SoundItem> _sounds = [
    // ── Nature ──────────────────────────────────────────────────────────────
    SoundItem(
      id: 'nature_backyard',
      name: 'Backyard Sounds',
      assetPath: 'assets/sounds/nature/Backyard-sounds.mp3',
      iconName: SoundIconName.yard.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_gentle_stream',
      name: 'Gentle Stream',
      assetPath:
          'assets/sounds/nature/Gentle-stream-with-falling-sleet-soothing-nature-sound.mp3',
      iconName: SoundIconName.water.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_rain_birds',
      name: 'Rain & Birdsong',
      assetPath:
          'assets/sounds/nature/Rainfall-with-bird-calls-sound-effect.mp3',
      iconName: SoundIconName.flutter_dash.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_birds_water',
      name: 'Birds & Water',
      assetPath:
          'assets/sounds/nature/Relaxing-birds-and-flowing-water-sound-effect.mp3',
      iconName: SoundIconName.water_drop.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_rain_stream',
      name: 'Rain & Stream',
      assetPath:
          'assets/sounds/nature/Relaxing-rain-and-stream-sounds-nature-sounds-for-sleep.mp3',
      iconName: SoundIconName.water_drop.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_stream_insects',
      name: 'Stream & Insects',
      assetPath:
          'assets/sounds/nature/Soothing-water-stream-and-calming-night-insect-sounds copy.mp3',
      iconName: SoundIconName.water.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_spring_forest',
      name: 'Spring Forest',
      assetPath: 'assets/sounds/nature/Spring-forest-sounds-for-relaxation.mp3',
      iconName: SoundIconName.forest.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_summer_insects',
      name: 'Summer Insects',
      assetPath:
          'assets/sounds/nature/Summer-night-insects-chirping-in-yard-sound-effect.mp3',
      iconName: SoundIconName.nights_stay.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_cicadas',
      name: 'Cicadas & Crickets',
      assetPath:
          'assets/sounds/nature/Summer-night-nature-ambience-sound-effect-cicadas-and-crickets.mp3',
      iconName: SoundIconName.nightlight.name,
      category: SoundCategory.nature,
    ),
    SoundItem(
      id: 'nature_waterfall_birds',
      name: 'Waterfall & Birds',
      assetPath:
          'assets/sounds/nature/Waterfall-and-birdsong-ambience-nature-white-noise-sound-effect.mp3',
      iconName: SoundIconName.waves.name,
      category: SoundCategory.nature,
    ),

    // ── Rain ────────────────────────────────────────────────────────────────
    SoundItem(
      id: 'rain_hail_window',
      name: 'Hail on Window',
      assetPath: 'assets/sounds/rain/Hail-hitting-a-window-sound-effect.mp3',
      iconName: SoundIconName.snowing.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_heavy',
      name: 'Heavy Rainfall',
      assetPath: 'assets/sounds/rain/Heavy-rainfall-sound-effect.mp3',
      iconName: SoundIconName.water_drop.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_city_storm',
      name: 'City Storm Rain',
      assetPath:
          'assets/sounds/rain/Heavy-storm-rain-in-city-street-ambience-sound-effect.mp3',
      iconName: SoundIconName.location_city.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_and_thunder',
      name: 'Rain & Thunder',
      assetPath:
          'assets/sounds/rain/Rain-and-thunder-sound-effect-realistic-rainy-weather-ambience.mp3',
      iconName: SoundIconName.thunderstorm.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_city',
      name: 'City Rain',
      assetPath:
          'assets/sounds/rain/Rain-falling-in-city-urban-ambience-sound-effect.mp3',
      iconName: SoundIconName.location_city.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_urban',
      name: 'Urban Rain',
      assetPath:
          'assets/sounds/rain/Rain-falling-in-urban-area-city-ambience-sound-effect.mp3',
      iconName: SoundIconName.apartment.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_car_window',
      name: 'Raindrops on Car',
      assetPath:
          'assets/sounds/rain/Raindrops-on-the-car-window-sound-effect.mp3',
      iconName: SoundIconName.directions_car.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_traffic',
      name: 'Rainy Traffic',
      assetPath:
          'assets/sounds/rain/Rainy-city-traffic-sound-cars-driving-on-wet-pavement.mp3',
      iconName: SoundIconName.traffic.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_sleet',
      name: 'Falling Sleet',
      assetPath: 'assets/sounds/rain/Sleet-falling-sound-effect.mp3',
      iconName: SoundIconName.grain.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_torrential_roof',
      name: 'Torrential Rain',
      assetPath:
          'assets/sounds/rain/Torrential-rain-hitting-roof-sound-effect.mp3',
      iconName: SoundIconName.roofing.name,
      category: SoundCategory.rain,
    ),
    SoundItem(
      id: 'rain_wind',
      name: 'Wind & Rain',
      assetPath: 'assets/sounds/rain/Wind-and-rain-sounds.mp3',
      iconName: SoundIconName.air.name,
      category: SoundCategory.rain,
    ),

    // ── Thunder ──────────────────────────────────────────────────────────────
    SoundItem(
      id: 'thunder_deep_city',
      name: 'Deep Thunder Strike',
      assetPath:
          'assets/sounds/thunder/Deep-thunder-strike-city-rain-ambience.mp3',
      iconName: SoundIconName.bolt.name,
      category: SoundCategory.thunder,
    ),
    SoundItem(
      id: 'thunder_distant_storm',
      name: 'Distant Storm',
      assetPath: 'assets/sounds/thunder/Distant-storm-thunder-sound-effect.mp3',
      iconName: SoundIconName.cloudy_snowing.name,
      category: SoundCategory.thunder,
    ),
    SoundItem(
      id: 'thunder_lightning',
      name: 'Lightning Strike',
      assetPath:
          'assets/sounds/thunder/Lightning-strike-and-thunder-sound-effect.mp3',
      iconName: SoundIconName.flash_on.name,
      category: SoundCategory.thunder,
    ),
    SoundItem(
      id: 'thunder_clap',
      name: 'Thunder Clap',
      assetPath: 'assets/sounds/thunder/Thunder-clap-sound-effect-no-rain.mp3',
      iconName: SoundIconName.thunderstorm.name,
      category: SoundCategory.thunder,
    ),
    SoundItem(
      id: 'thunder_city_rumble',
      name: 'City Thunder Rumble',
      assetPath:
          'assets/sounds/thunder/Thunder-rumble-in-rainy-city-ambience-sound-effect.mp3',
      iconName: SoundIconName.bolt.name,
      category: SoundCategory.thunder,
    ),
  ];

  @override
  Future<List<SoundItem>> getAllSounds() async {
    return _sounds;
  }

  @override
  Future<List<SoundItem>> getByCategory(SoundCategory category) async {
    return _sounds.where((s) => s.category == category).toList();
  }

}
