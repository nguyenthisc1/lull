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
  Future<void> toggleSound() async {
    if (state.currentSingle == null) return;

    final currentSound = state.currentSingle?.sound;

    if (state is AudioIdle || state is AudioSingle) {
      return await playSingle(currentSound!);
    }

    if (state is AudioMixing) {
      return await playMixer(currentSound!);
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

  Future<void> _stopSound() async {
    if (state is AudioSingle) {
      await _service.stopSingle();
    } else {
      await _service.stopAllMulti();
    }
  }

  void setVolume(AudioItemState soundItemState, double v) {
    if (state is AudioMixing) {
      // Update only the passed-in sound in a new map, do not read back from state
      final currentMap = Map<String, AudioItemState>.from(
        (state as AudioMixing).mixerSounds,
      );
      currentMap[soundItemState.sound.id] = soundItemState.copyWith(volume: v);
      state = AudioMixing(mixerSounds: currentMap);

      _service.setMultiVolume(soundItemState.sound.id, v);
    } else if (state is AudioSingle) {
      // Just update with the passed soundItemState
      state = (state as AudioSingle).copyWith(
        singleSound: soundItemState.copyWith(volume: v),
      );

      _service.setSingleVolume(v);
    }
  }

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
