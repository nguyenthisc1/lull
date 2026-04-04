// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/services/player_service.dart';

/// Observable mode — updated automatically by add/remove logic.
final audioModeProvider = StateProvider<AudioMode>((ref) => AudioMode.single);

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;
  final Ref _ref;

  AudioNotifier({required AudioPlayerService service, required Ref ref})
    : _service = service,
      _ref = ref,
      super(AudioIdle());

  AudioMode get _mode => _ref.read(audioModeProvider);

  // ── Internal helpers ────────────────────────────────────────────────────────

  void _setMode(AudioMode mode) =>
      _ref.read(audioModeProvider.notifier).state = mode;

  Future<void> _handleSingleTransition(
    AudioState oldState,
    AudioSingle newState,
    SoundItem sound,
  ) async {
    if (oldState is AudioMixing) {
      await _service.disposeAllMulti();
      await _service.playSingle(sound.id, sound.assetPath);
      return;
    }

    final isNewSound =
        oldState is! AudioSingle || oldState.singleSound.sound.id != sound.id;

    if (isNewSound) {
      if (oldState is AudioSingle) await _service.disposeSingle();
      await _service.playSingle(sound.id, sound.assetPath);
      return;
    }

    newState.singleSound.playbackState == PlaybackState.playing
        ? await _service.resumeSingle()
        : await _service.pauseSingle();
  }

  Future<void> _handleMixingTransition(
    AudioState oldState,
    SoundItem sound,
  ) async {
    final removedFromMixer =
        oldState is AudioMixing && oldState.mixerSounds.containsKey(sound.id);

    if (removedFromMixer) {
      await _service.stopMulti(sound.id);
    } else {
      if (oldState is AudioSingle) await _service.disposeSingle();
      await _service.playMulti(sound.id, sound.assetPath);
    }
  }

  Future<void> _handleIdleTransition(
    AudioState oldState,
    SoundItem sound,
  ) async {
    if (oldState is AudioMixing) await _service.stopMulti(sound.id);
    if (oldState is AudioSingle) await _service.stopSingle();
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Always plays [sound] in single mode, stopping any active mix first.
  Future<void> playSingle(SoundItem sound) async {
    final previousState = state;

    try {
      if (_mode != AudioMode.single) {
        _setMode(AudioMode.single);
        state = AudioIdle();
        await _service.stopAllMulti();
      }

      final newState = state.toggle(sound, AudioMode.single);
      state = newState;

      switch (newState) {
        case AudioSingle():
          await _handleSingleTransition(previousState, newState, sound);
        case AudioIdle():
          await _handleIdleTransition(previousState, sound);
        default:
          break;
      }
    } catch (e) {
      state = previousState;
      print('AudioNotifier.playSingle Error: $e');
    }
  }

  /// Adds [sound] to the mix, switching to mixing mode automatically.
  /// If currently playing a single sound it is stopped before switching.
  Future<void> addToMix(SoundItem sound) async {
    final previousState = state;

    try {
      if (_mode == AudioMode.single) {
        _setMode(AudioMode.mixing);
        if (state is AudioSingle) {
          state = AudioIdle();
          await _service.disposeSingle();
        }
      }

      // Sound already in mix → nothing to do.
      if (state is AudioMixing &&
          (state as AudioMixing).mixerSounds.containsKey(sound.id)) {
        return;
      }

      final newState = state.toggle(sound, AudioMode.mixing);
      state = newState;

      if (newState is AudioMixing) {
        await _handleMixingTransition(previousState, sound);
      }
    } catch (e) {
      state = previousState;
      print('AudioNotifier.addToMix Error: $e');
    }
  }

  /// Removes [sound] from the mix.
  /// Auto-demotes to single mode when ≤ 1 sound remains.
  Future<void> removeFromMix(SoundItem sound) async {
    if (state is! AudioMixing) return;

    final mixing = state as AudioMixing;
    if (!mixing.mixerSounds.containsKey(sound.id)) return;

    final updated = Map<String, AudioItemState>.from(mixing.mixerSounds)
      ..remove(sound.id);

    // Update state + mode synchronously FIRST so the UI is immediately
    // consistent, then run service calls in the background.
    if (updated.isEmpty) {
      state = AudioIdle();
      _setMode(AudioMode.single);
      await _service.stopMulti(sound.id);
    } else if (updated.length == 1) {
      final remaining = updated.values.first;
      // Both updates in the same synchronous block → single rebuild frame.
      _setMode(AudioMode.single);
      state = AudioSingle(
        singleSound: remaining.copyWith(playbackState: PlaybackState.playing),
      );
      // Service calls after state is already committed.
      await _service.stopMulti(sound.id);
      await _service.disposeAllMulti();
      await _service.playSingle(remaining.sound.id, remaining.sound.assetPath);
    } else {
      state = AudioMixing(mixerSounds: updated);
      await _service.stopMulti(sound.id);
    }
  }

  /// Toggles play/pause for a single sound inside the mixer.
  /// Also works for single-mode (delegates to [playSingle]).
  Future<void> toggleMixerSound(AudioItemState soundItemState) async {
    if (state is AudioSingle) {
      await playSingle(soundItemState.sound);
      return;
    }

    if (state is! AudioMixing) return;

    final isPlaying = soundItemState.playbackState == PlaybackState.playing;
    final updated = Map<String, AudioItemState>.from(
      (state as AudioMixing).mixerSounds,
    );
    updated[soundItemState.sound.id] = soundItemState.copyWith(
      playbackState: isPlaying ? PlaybackState.paused : PlaybackState.playing,
    );
    state = AudioMixing(mixerSounds: updated);

    if (isPlaying) {
      await _service.stopMulti(soundItemState.sound.id);
    } else {
      await _service.resumeMulti(soundItemState.sound.id);
    }
  }

  /// Toggle play/pause across all active sounds.
  Future<void> togglePlayAll() async {
    if (state is AudioSingle) {
      await playSingle((state as AudioSingle).singleSound.sound);
    } else if (state is AudioMixing) {
      final mixing = state as AudioMixing;

      if (mixing.isAnyPlaying) {
        final updated = Map<String, AudioItemState>.from(mixing.mixerSounds);
        updated.updateAll(
          (_, v) => v.copyWith(playbackState: PlaybackState.paused),
        );
        state = AudioMixing(mixerSounds: updated);
        await _service.stopAllMulti();
      } else {
        for (final s in mixing.mixerSounds.values) {
          await _service.resumeMulti(s.sound.id);
        }
        final updated = Map<String, AudioItemState>.from(mixing.mixerSounds);
        updated.updateAll(
          (_, v) => v.copyWith(playbackState: PlaybackState.playing),
        );
        state = AudioMixing(mixerSounds: updated);
      }
    }
  }

  /// Resets to idle and changes mode (used for hard resets if needed).
  Future<void> setMode(AudioMode mode) async {
    _setMode(mode);
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
  return AudioNotifier(service: AudioPlayerService(), ref: ref);
});
