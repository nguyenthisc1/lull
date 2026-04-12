// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/library_model.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/repositories/library_storage.dart';
import 'package:lull/repositories/playback_storage.dart';

class LibraryNotifier extends AsyncNotifier<List<LibraryItem>> {
  @override
  Future<List<LibraryItem>> build() => LibraryStorage.loadAll();

  /// Saves the current audio state as a named library preset.
  Future<void> addLibrary({
    required String name,
    required AudioState audioState,
    required AudioMode mode,
    int? timerSeconds,
  }) async {
    if (audioState is AudioIdle) return;

    final sounds = audioState.sounds
        .map(
          (item) => LibrarySoundEntry(
            soundId: item.sound.id,
            volume: item.volume ?? 0.5,
          ),
        )
        .toList();

    final item = LibraryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      sounds: sounds,
      timerSeconds: timerSeconds,
      createdAt: DateTime.now(),
    );

    await LibraryStorage.save(item);
    state = AsyncData(await LibraryStorage.loadAll());
  }

  Future<void> deleteLibrary(String id) async {
    await LibraryStorage.delete(id);
    state = AsyncData(await LibraryStorage.loadAll());
  }

  /// Loads a saved library preset into the audio provider and starts playback.
  Future<void> loadLibrary(LibraryItem item) async {
    try {
      final mode = item.sounds.length == 1 ? AudioMode.single : AudioMode.mixing;

      final entries = item.sounds
          .map((s) => PlaybackSoundEntry(soundId: s.soundId, volume: s.volume))
          .toList();

      await ref.read(audioProvider.notifier).restoreFromEntries(entries, mode);
    } catch (e) {
      print('LibraryNotifier.loadLibrary Error: $e');
    }
  }
}

final libraryProvider =
    AsyncNotifierProvider<LibraryNotifier, List<LibraryItem>>(
      LibraryNotifier.new,
    );
