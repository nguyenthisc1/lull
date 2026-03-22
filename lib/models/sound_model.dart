import 'package:equatable/equatable.dart';

enum SoundCategory { nature, rain, thunder, whiteNoise, urban }

enum SoundIconName {
  // Nature
  yard,
  water,
  forest,
  flutter_dash,
  air,
  water_drop,
  nights_stay,
  nightlight,
  waves,

  // Rain / Weather / Urban
  snowing,
  location_city,
  thunderstorm,
  apartment,
  directions_car,
  traffic,
  grain,
  roofing,

  // Thunder
  bolt,
  cloudy_snowing,
  flash_on,

  // Fallbacks & additional
  unknown,
}

class SoundItem extends Equatable {
  final String id;
  final String name;
  final String assetPath;
  final String iconName;
  final SoundCategory category;

  const SoundItem({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.iconName,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, assetPath, iconName, category];

  SoundItem copyWith({
    String? id,
    String? name,
    String? assetPath,
    String? iconName,
    SoundCategory? category,
  }) {
    return SoundItem(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      iconName: iconName ?? this.iconName,
      category: category ?? this.category,
    );
  }
}
