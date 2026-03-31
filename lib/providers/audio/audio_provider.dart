// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/services/player_service.dart';

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;
  AudioMode _mode = AudioMode.single;

  AudioNotifier({required AudioPlayerService service})
    : _service = service,
      super(AudioIdle());

  /// Optimistic toggle: state updates immediately for responsive UI,
  /// then service calls are made. On error the old state is restored.
  Future<void> handleToggleSound(SoundItem sound) async {
    final oldState = state;
    final newState = oldState.toggle(sound, _mode);

    state = newState;

    try {
      if (newState is AudioSingle) {
        final isNewSound =
            oldState is! AudioSingle ||
            oldState.singleSound.sound.id != sound.id;

        if (isNewSound) {
          if (oldState is AudioSingle) await _service.disposeSingle();
          if (oldState is AudioMixing) await _service.disposeAllMulti();
          await _service.playSingle(sound.id, sound.assetPath);
        } else if (newState.singleSound.playbackState == PlaybackState.playing) {
          await _service.resumeSingle();
        } else {
          await _service.pauseSingle();
        }
      } else if (newState is AudioMixing) {
        final soundRemovedFromMixer =
            oldState is AudioMixing && oldState.mixerSounds.containsKey(sound.id);

        if (soundRemovedFromMixer) {
          await _service.stopMulti(sound.id);
        } else {
          if (oldState is AudioSingle) await _service.disposeSingle();
          await _service.playMulti(sound.id, sound.assetPath);
        }
      } else if (newState is AudioIdle) {
        // Last mixer sound was removed
        if (oldState is AudioMixing) await _service.stopMulti(sound.id);
        if (oldState is AudioSingle) await _service.stopSingle();
      }
    } catch (e) {
      state = oldState;
      print('AudioNotifier Error: $e');
    }
  }

  Future<void> setMode(AudioMode mode) async {
    _mode = mode;
    state = AudioIdle();
    await _service.stopAll();
  }

  void setVolume(AudioItemState soundItemState, double v) {
    if (state is AudioMixing) {
      final currentMap = Map<String, AudioItemState>.from(
        (state as AudioMixing).mixerSounds,
      );
      currentMap[soundItemState.sound.id] = soundItemState.copyWith(volume: v);
      state = AudioMixing(mixerSounds: currentMap);
      _service.setMultiVolume(soundItemState.sound.id, v);
    } else if (state is AudioSingle) {
      state = (state as AudioSingle).copyWith(
        singleSound: soundItemState.copyWith(volume: v),
      );
      _service.setSingleVolume(v);
    }
  }

  Future<void> stopAll() async {
    state = await state.stop(_service);
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  ref.keepAlive();
  final audioService = AudioPlayerService();
  return AudioNotifier(service: audioService);
});
