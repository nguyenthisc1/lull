import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sound_model.dart';
import '../repositories/sounds_repository.dart';

/// Provides the list of all sounds.
final allSoundsProvider = Provider<List<SoundItem>>((ref) {
  return SoundsRepository.all;
});

/// Provides sounds filtered by category.
final soundsByCategoryProvider =
    Provider.family<List<SoundItem>, SoundCategory>((ref, category) {
      return SoundsRepository.byCategory(category);
    });

final selectedCategoryProvider = StateProvider<SoundCategory?>(
  (ref) => null,
);

final filteredSoundsProvider = Provider<List<SoundItem>>((ref) {
  final allSounds = ref.watch(allSoundsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == null) return allSounds;
  return allSounds.where((s) => s.category == selectedCategory).toList();
});
