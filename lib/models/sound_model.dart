import 'package:equatable/equatable.dart';

enum SoundCategory {
  nature,
  rain,
  thunder,
  whiteNoise,
  urban;

  static SoundCategory fromString(String value) {
    return SoundCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SoundCategory.nature,
    );
  }
}

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'assetPath': assetPath,
    'iconName': iconName,
    'category': category.name,
  };

  factory SoundItem.fromJson(Map<String, dynamic> json) => SoundItem(
    id: json['id'] as String,
    name: json['name'] as String,
    assetPath: json['assetPath'] as String,
    iconName: json['iconName'] as String,
    category: SoundCategory.fromString(json['category'] as String),
  );
}
