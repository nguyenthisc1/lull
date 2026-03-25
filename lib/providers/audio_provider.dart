// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/services/player_service.dart';

enum AudioMode { idle, mixing, single }

enum PlaybackState { stopped, playing, paused }

class SoundItemState extends Equatable {
  final SoundItem sound;
  final double volume;
  final PlaybackState playbackState;

  const SoundItemState({
    required this.volume,
    required this.playbackState,
    required this.sound,
  });

  SoundItemState copyWith({
    SoundItem? sound,
    double? volume,
    PlaybackState? playbackState,
  }) {
    return SoundItemState(
      sound: sound ?? this.sound,
      volume: volume ?? this.volume,
      playbackState: playbackState ?? this.playbackState,
    );
  }

  @override
  List<Object?> get props => [volume, playbackState];
}

class AudioState extends Equatable {
  final Map<String, SoundItemState> mixerSounds;
  final SoundItemState? singleSound;
  final AudioMode mode;

  const AudioState({
    this.mixerSounds = const {},
    this.mode = AudioMode.mixing,
    this.singleSound,
  });

  AudioState copyWith({
    Map<String, SoundItemState>? mixerSounds,
    SoundItemState? singleSound,
    AudioMode? mode,
  }) {
    return AudioState(
      mixerSounds: mixerSounds ?? this.mixerSounds,
      singleSound: singleSound ?? this.singleSound,
      mode: mode ?? this.mode,
    );
  }

  @override
  List<Object?> get props => [mixerSounds, singleSound, mode];
}

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;

  AudioNotifier({required AudioPlayerService service})
    : _service = service,
      super(const AudioState());

  /// Toggle a sound in the current mode.
  Future<void> toggleSound(SoundItem sound, AudioMode mode) async {
    // await _stopSound();
    if (mode == AudioMode.single) {
      await playSingle(sound);
    } else if (mode == AudioMode.mixing) {
      await playMixer(sound);
    }
  }

  /// Play a single sound (solo mode)
  Future<void> playSingle(SoundItem sound) async {
    final isSameSingleSound = state.singleSound?.sound.id == sound.id;

    if (!isSameSingleSound) {
      // Stop all mixer tracks and clear
      await _service.disposeAllMulti();

      state = state.copyWith(
        mode: AudioMode.single,
        singleSound: SoundItemState(
          sound: sound,
          volume: 0.5,
          playbackState: PlaybackState.playing,
        ),
        mixerSounds: {},
      );

      await _service.playSingle(sound.id, sound.assetPath);
      return;
    }

    if (state.singleSound?.playbackState == PlaybackState.playing) {
      final newSingleSound = state.singleSound?.copyWith(
        playbackState: PlaybackState.paused,
      );
      state = state.copyWith(singleSound: newSingleSound);

      await _service.pauseSingle();
    } else {
      final newSingleSound = state.singleSound?.copyWith(
        playbackState: PlaybackState.playing,
      );

      state = state.copyWith(singleSound: newSingleSound);

      await _service.resumeSingle();
    }
  }

  /// Add or resume a sound in the mixer (multi) mode
  Future<void> playMixer(SoundItem sound) async {
    final mixerSounds = Map<String, SoundItemState>.from(state.mixerSounds);
    final hasSound = mixerSounds.containsKey(sound.id);

    if (!hasSound) {
      // Stop single if moving to mixer
      await _service.disposeSingle();

      mixerSounds[sound.id] = SoundItemState(
        sound: sound,
        volume: 0.5,
        playbackState: PlaybackState.playing,
      );

      state = state.copyWith(
        mixerSounds: mixerSounds,
        singleSound: null,
        mode: AudioMode.mixing,
      );
      await _service.playMulti(sound.id, sound.assetPath);
      return;
    }

    final currentSoundState = mixerSounds[sound.id];
    if (currentSoundState == null) return;

    // Toggle playback state
    final isPlaying = currentSoundState.playbackState == PlaybackState.playing;
    final newPlaybackState = isPlaying
        ? PlaybackState.paused
        : PlaybackState.playing;

    mixerSounds[sound.id] = currentSoundState.copyWith(
      playbackState: newPlaybackState,
    );

    state = state.copyWith(mixerSounds: mixerSounds);

    if (isPlaying) {
      await _service.stopMulti(currentSoundState.sound.id);
    } else {
      await _service.resumeMulti(currentSoundState.sound.id);
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
  //     final newMixer = <String, SoundItemState>{};
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
    if (state.mode == AudioMode.single) {
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
  //       final newSingle = Map<String, SoundItemState>.from(state.singleSound)
  //         ..[id] = current.copyWith(volume: volume);
  //       state = state.copyWith(singleSound: newSingle);
  //       _service.setSingleVolume(volume);
  //     }
  //   } else {
  //     // Mixer (multi) mode
  //     if (state.mixerSounds.containsKey(id)) {
  //       final current = state.mixerSounds[id]!;
  //       final newMixer = Map<String, SoundItemState>.from(state.mixerSounds)
  //         ..[id] = current.copyWith(volume: volume);
  //       state = state.copyWith(mixerSounds: newMixer);
  //       _service.setMultiVolume(id, volume);
  //     }
  //   }
  // }

  /// Stop all currently playing sounds and reset state.
  void stopAll() {
    _service.stopAll();
    state = state.copyWith(
      mixerSounds: {},
      singleSound: null,
      mode: AudioMode.idle,
    );
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
