import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sound_model.dart';
import '../repositories/sounds_repository.dart';

// --- SEALED STATE ---
sealed class SoundState {
  const SoundState();
}

class SoundInitial extends SoundState {
  const SoundInitial();
}

class SoundLoading extends SoundState {
  const SoundLoading();
}

class SoundLoaded extends SoundState {
  final List<SoundItem> sounds;
  final SoundCategory? selectedCategory;

  const SoundLoaded({required this.sounds, this.selectedCategory});
}

class SoundError extends SoundState {
  final String errorMessage;
  const SoundError(this.errorMessage);
}

// --- NOTIFIER ---
class SoundNotifier extends StateNotifier<SoundState> {
  final SoundsRepository repository;

  List<SoundItem> _allSounds = [];

  SoundNotifier(this.repository) : super(const SoundInitial());

  Future<void> loadAllSounds() async {
    state = const SoundLoading();
    try {
      _allSounds = await repository.getAllSounds();
      state = SoundLoaded(sounds: _allSounds, selectedCategory: null);
    } catch (e) {
      state = SoundError('Failed to load sounds: $e');
    }
  }

  Future<void> loadByCategory(SoundCategory? category) async {
    if (state is SoundLoaded) return;

    state = const SoundLoading();

    if (category == null) {
      state = SoundLoaded(sounds: _allSounds);
      return;
    }

    final filtered = _allSounds.where((s) => s.category == category).toList();

    state = SoundLoaded(sounds: filtered, selectedCategory: category);
  }
}

// --- PROVIDERS ---
final soundsRepositoryProvider = Provider<SoundsRepository>(
  (ref) => LocalSoundsRepository(),
);

final soundProvider = StateNotifierProvider<SoundNotifier, SoundState>((ref) {
  final repo = ref.watch(soundsRepositoryProvider);
  final notifier = SoundNotifier(repo);
  notifier.loadAllSounds();
  return notifier;
});
