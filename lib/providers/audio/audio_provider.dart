// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/services/player_service.dart';

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;

  AudioNotifier({required AudioPlayerService service})
    : _service = service,
      super(AudioIdle());

  /// Toggle a sound in the current mode.
  Future<void> toggleSound(SoundItem sound) async {
    if (state is AudioIdle || state is AudioSingle) {
      return await playSingle(sound);
    }

    if (state is AudioMixing) {
      return await playMixer(sound);
    }
  }

  /// Play a single sound (solo mode)
  Future<void> playSingle(SoundItem sound) async {
    if (state is AudioSingle) {
      final current = (state as AudioSingle).singleSound;
      final isSameSound = current.sound.id == sound.id;

      if (!isSameSound) {
        await _service.disposeAllMulti();
        state = AudioSingle(
          singleSound: AudioItemState(
            volume: 0.5,
            playbackState: PlaybackState.playing,
            sound: sound,
          ),
        );
        await _service.playSingle(sound.id, sound.assetPath);
        return;
      }

      if (current.playbackState == PlaybackState.playing) {
        state = AudioSingle(
          singleSound: current.copyWith(playbackState: PlaybackState.paused),
        );
        await _service.pauseSingle();
      } else {
        state = AudioSingle(
          singleSound: current.copyWith(playbackState: PlaybackState.playing),
        );
        await _service.resumeSingle();
      }
      return;
    }

    // From idle or mixing state — start fresh single playback
    await _service.disposeAllMulti();
    state = AudioSingle(
      singleSound: AudioItemState(
        volume: 0.5,
        playbackState: PlaybackState.playing,
        sound: sound,
      ),
    );
    await _service.playSingle(sound.id, sound.assetPath);
  }

  /// Add or resume a sound in the mixer (multi) mode
  Future<void> playMixer(SoundItem sound) async {
    if (state is! AudioMixing) return;

    final Map<String, AudioItemState> mapSounds =
        (state as AudioMixing).mixerSounds;
    final hasSound = mapSounds.containsKey(sound.id);

    if (!hasSound) {
      // Stop single if moving to mixer
      await _service.disposeSingle();

      mapSounds[sound.id] = AudioItemState(
        sound: sound,
        volume: 0.5,
        playbackState: PlaybackState.playing,
      );

      state = AudioMixing(mixerSounds: mapSounds);

      await _service.playMulti(sound.id, sound.assetPath);
      return;
    }

    final currentSound = mapSounds[sound.id];
    if (currentSound == null) return;

    // Toggle playback state
    final isPlaying = currentSound.playbackState == PlaybackState.playing;
    final newPlaybackState = isPlaying
        ? PlaybackState.paused
        : PlaybackState.playing;

    mapSounds[sound.id] = currentSound.copyWith(
      playbackState: newPlaybackState,
    );

    state = AudioMixing(mixerSounds: mapSounds);

    if (isPlaying) {
      await _service.stopMulti(currentSound.sound.id);
    } else {
      await _service.resumeMulti(currentSound.sound.id);
    }
  }

  /// Resume playback for a sound in single mode if it's paused
  // Future<void> resumeSingle(SoundItem sound) async {
  //   final id = sound.id;

  //   if (state.mode != AudioMode.single || !state.singleSound.containsKey(id)) {
  //     return;
  //   }

  //   final current = state.singleSound[id]!;

  //   final isPaused = current.playbackState == PlaybackState.paused;
  //   final newPlaybackState = isPaused
  //       ? PlaybackState.playing
  //       : PlaybackState.paused;
  //   final newSingle = {
  //     ...state.singleSound,
  //     id: current.copyWith(playbackState: newPlaybackState),
  //   };

  //   state = state.copyWith(singleSound: newSingle);

  //   if (isPaused) {
  //     await _service.playSingle(id, sound.assetPath);
  //   } else {
  //     await _service.pauseSingle();
  //   }
  // }

  /// Resume playback for all paused mixer sounds
  // Future<void> resumeMixer() async {
  //   if (state.mode == AudioMode.mixing) {
  //     final newMixer = <String, AudioItemState>{};
  //     bool changed = false;
  //     for (var entry in state.mixerSounds.entries) {
  //       if (entry.value.playbackState == PlaybackState.paused) {
  //         newMixer[entry.key] = entry.value.copyWith(
  //           playbackState: PlaybackState.playing,
  //         );
  //         await _service.resumeMulti(entry.key);
  //         changed = true;
  //       } else {
  //         newMixer[entry.key] = entry.value;
  //       }
  //     }
  //     if (changed) {
  //       state = state.copyWith(mixerSounds: newMixer);
  //     }
  //   }
  // }

  Future<void> _stopSound() async {
    if (state is AudioSingle) {
      await _service.stopSingle();
    } else {
      await _service.stopAllMulti();
    }
  }

  /// Update the volume of a sound by id.
  // void updateVolume(String id, double volume) {
  //   if (state.mode == AudioMode.single) {
  //     // Single track volume change, only one entry in map
  //     if (state.singleSound.containsKey(id)) {
  //       final current = state.singleSound[id]!;
  //       final newSingle = Map<String, AudioItemState>.from(state.singleSound)
  //         ..[id] = current.copyWith(volume: volume);
  //       state = state.copyWith(singleSound: newSingle);
  //       _service.setSingleVolume(volume);
  //     }
  //   } else {
  //     // Mixer (multi) mode
  //     if (state.mixerSounds.containsKey(id)) {
  //       final current = state.mixerSounds[id]!;
  //       final newMixer = Map<String, AudioItemState>.from(state.mixerSounds)
  //         ..[id] = current.copyWith(volume: volume);
  //       state = state.copyWith(mixerSounds: newMixer);
  //       _service.setMultiVolume(id, volume);
  //     }
  //   }
  // }

  /// Stop all currently playing sounds and reset state.
  void stopAll() {
    _service.stopAll();
    state = AudioIdle();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  ref.keepAlive();
  final audioService = AudioPlayerService();
  return AudioNotifier(service: audioService);
});
