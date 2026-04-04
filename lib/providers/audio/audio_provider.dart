// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/services/player_service.dart';

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;

  AudioNotifier({required AudioPlayerService service})
    : _service = service,
      super(AudioIdle());

  Future<void> handleToggleSound(SoundItem sound) async {
    final previousState = state;

    try {
      final newState = state.toggle(sound);
      state = newState;

      switch (newState.runtimeType) {
        case AudioSingle:
          await _playSingleMode(previousState, newState as AudioSingle, sound);
          break;
        case AudioMixing:
          await _playMixingMode(previousState, sound);
          break;
        case AudioIdle _:
          await _playIdleMode(previousState, sound);
          break;
        default:
          break;
      }
    } catch (e) {
      state = previousState;
      print('AudioNotifier Error: $e');
    }
  }

  Future<void> _playSingleMode(
    AudioState oldState,
    AudioSingle newState,
    SoundItem sound,
  ) async {
    final isNewSound =
        oldState is! AudioSingle || oldState.singleSound.sound.id != sound.id;

    if (isNewSound) {
      if (oldState is AudioSingle) await _service.disposeSingle();
      if (oldState is AudioMixing) await _service.disposeAllMulti();
      await _service.playSingle(sound.id, sound.assetPath);
    } else if (newState.singleSound.playbackState == PlaybackState.playing) {
      await _service.resumeSingle();
    } else {
      await _service.pauseSingle();
    }
  }

  Future<void> _playMixingMode(AudioState oldState, SoundItem sound) async {
    final soundRemovedFromMixer =
        oldState is AudioMixing && oldState.mixerSounds.containsKey(sound.id);

    if (soundRemovedFromMixer) {
      await _service.stopMulti(sound.id);
    } else {
      if (oldState is AudioSingle) await _service.disposeSingle();
      await _service.playMulti(sound.id, sound.assetPath);
    }
  }

  Future<void> _playIdleMode(AudioState oldState, SoundItem sound) async {
    if (oldState is AudioMixing) await _service.stopMulti(sound.id);
    if (oldState is AudioSingle) await _service.stopSingle();
  }

  Future<AudioMixing?> addToMix(SoundItem sound) async {
    if (state is AudioMixing) {
      final mixingState = state as AudioMixing;
      if (!mixingState.mixerSounds.containsKey(sound.id)) {
        final updatedMap = Map<String, AudioItemState>.from(
          mixingState.mixerSounds,
        );
        updatedMap[sound.id] = AudioItemState(
          sound: sound,
          playbackState: PlaybackState.playing,
          volume: 0.5,
        );
        state = AudioMixing(mixerSounds: updatedMap);
        await _service.playMulti(sound.id, sound.assetPath);
        return state as AudioMixing;
      }
    }
    return null;
  }

  Future<AudioMixing?> deleteToMix(SoundItem sound) async {
    if (state is AudioMixing) {
      final mixingState = state as AudioMixing;
      if (mixingState.mixerSounds.containsKey(sound.id)) {
        final updatedMap = Map<String, AudioItemState>.from(
          mixingState.mixerSounds,
        );
        updatedMap.remove(sound.id);
        if (updatedMap.isEmpty) {
          state = AudioIdle();
        } else {
          state = AudioMixing(mixerSounds: updatedMap);
        }
        await _service.stopMulti(sound.id);
        if (state is AudioMixing) {
          return state as AudioMixing;
        }
      }
    }
    return null;
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
