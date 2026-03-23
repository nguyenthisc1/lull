// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/services/player_service.dart';

class MixerSoundState extends Equatable {
  final double volume;
  final bool isPlaying;

  const MixerSoundState({required this.volume, required this.isPlaying});

  MixerSoundState copyWith({double? volume, bool? isPlaying}) {
    return MixerSoundState(
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [volume, isPlaying];
}

class MixerState extends Equatable {
  final Map<String, MixerSoundState> activeSounds;

  const MixerState({this.activeSounds = const {}});

  MixerState copyWith({Map<String, MixerSoundState>? activeSounds}) {
    return MixerState(activeSounds: activeSounds ?? this.activeSounds);
  }

  @override
  List<Object?> get props => [activeSounds];
}

class MixerNotifier extends StateNotifier<MixerState> {
  final AudioPlayerService _service;

  MixerNotifier({required AudioPlayerService service})
    : _service = service,
      super(const MixerState());

  Future<void> toggleSound(SoundItem sound) async {
    final id = sound.id;
    final currentSoundState = state.activeSounds[id];

    if (currentSoundState != null && currentSoundState.isPlaying) {
      state = _updateSoundState(id, isPlaying: false);
      await _service.stop(id);
    } else if (currentSoundState != null && !currentSoundState.isPlaying) {
      state = _updateSoundState(id, isPlaying: true);
      await _service.resume(id);
    } else {
      state = _updateSoundState(id, isPlaying: true, isNew: true);
      await _service.newPlaySound(id, sound.assetPath);
    }
  }

  MixerState _updateSoundState(
    String id, {
    required bool isPlaying,
    bool isNew = false,
  }) {
    final newActive = Map<String, MixerSoundState>.from(state.activeSounds);
    if (isNew || !newActive.containsKey(id)) {
      newActive[id] = MixerSoundState(volume: 0.5, isPlaying: isPlaying);
    } else {
      newActive[id] = MixerSoundState(
        volume: newActive[id]!.volume,
        isPlaying: isPlaying,
      );
    }
    return state.copyWith(activeSounds: newActive);
  }

  void updateVolume(String id, double volume) {
    final current = state.activeSounds[id];
    if (current != null) {
      final newActive = Map<String, MixerSoundState>.from(state.activeSounds)
        ..[id] = MixerSoundState(volume: volume, isPlaying: current.isPlaying);
      state = state.copyWith(activeSounds: newActive);
      _service.setVolume(id, volume);
    }
  }

  void stopAll() {
    _service.stopAll();

    state = state.copyWith(activeSounds: {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final mixerProvider = StateNotifierProvider<MixerNotifier, MixerState>((ref) {
  ref.keepAlive();
  final audioService = AudioPlayerService();
  return MixerNotifier(service: audioService);
});
