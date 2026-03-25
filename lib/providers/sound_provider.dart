import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sound_model.dart';
import '../repositories/sounds_repository.dart';

/// Provider for all sounds.
final allSoundsProvider = Provider<List<SoundItem>>(
  (ref) => SoundsRepository.all,
);

/// Provider for sounds by category.
final soundsByCategoryProvider = Provider.family<List<SoundItem>, SoundCategory>(
  (ref, category) => SoundsRepository.byCategory(category),
);

/// Provider for currently selected category.
final selectedCategoryProvider = StateProvider<SoundCategory?>(
  (ref) => null,
);

/// Provider for sounds filtered by the selected category.
final filteredSoundsProvider = Provider<List<SoundItem>>((ref) {
  final allSounds = ref.watch(allSoundsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return selectedCategory == null
      ? allSounds
      : allSounds.where((sound) => sound.category == selectedCategory).toList();
});
