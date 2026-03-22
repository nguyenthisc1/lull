import 'package:flutter/material.dart';
import 'package:lull/models/sound_model.dart';

class ActiveSound {
  const ActiveSound({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.volume,
  });

  final String id;
  final String name;
  final SoundCategory category;
  final IconData icon;
  final double volume;
}

const mockSounds = [
  ActiveSound(
    id: 'rain',
    name: 'Gentle Rain',
    category: SoundCategory.rain,
    icon: Icons.water_drop_outlined,
    volume: 0.75,
  ),
  ActiveSound(
    id: 'thunder',
    name: 'Distant Thunder',
    category: SoundCategory.thunder,
    icon: Icons.thunderstorm_outlined,
    volume: 0.40,
  ),
  ActiveSound(
    id: 'forest',
    name: 'Forest Ambience',
    category: SoundCategory.nature,
    icon: Icons.park_outlined,
    volume: 0.60,
  ),
];

const timerPresets = [15, 30, 45, 60, 90];
