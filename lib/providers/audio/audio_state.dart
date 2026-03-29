import 'package:equatable/equatable.dart';
import 'package:lull/models/sound_model.dart';

enum PlaybackState { stopped, playing, paused }

class AudioItemState extends Equatable {
  final SoundItem sound;
  final double volume;
  final PlaybackState playbackState;

  const AudioItemState({
    required this.volume,
    required this.playbackState,
    required this.sound,
  });

  AudioItemState copyWith({
    SoundItem? sound,
    double? volume,
    PlaybackState? playbackState,
  }) {
    return AudioItemState(
      sound: sound ?? this.sound,
      volume: volume ?? this.volume,
      playbackState: playbackState ?? this.playbackState,
    );
  }

  @override
  List<Object?> get props => [sound, volume, playbackState];
}

sealed class AudioState extends Equatable {
  List<AudioItemState> get sounds;
  AudioItemState? get currentSingle;

  @override
  List<Object?> get props => [];
}

class AudioIdle extends AudioState {
  static const _empty = <AudioItemState>[];

  @override
  List<AudioItemState> get sounds => _empty;

  @override
  AudioItemState? get currentSingle => null;

  @override
  List<Object?> get props => [];
}

class AudioMixing extends AudioState {
  final Map<String, AudioItemState> mixerSounds;
  late final List<AudioItemState> _sounds = List.unmodifiable(
    mixerSounds.values,
  );

  AudioMixing({required Map<String, AudioItemState> mixerSounds})
    : mixerSounds = Map.unmodifiable(mixerSounds);

  AudioMixing copyWith({Map<String, AudioItemState>? mixerSounds}) {
    return AudioMixing(mixerSounds: mixerSounds ?? this.mixerSounds);
  }

  AudioMixing addSound(String id, AudioItemState sound) {
    final newMap = Map<String, AudioItemState>.from(mixerSounds);
    newMap[id] = sound;

    return AudioMixing(mixerSounds: newMap);
  }

  // Bad performance when get sounds create new list
  // @override
  // List<AudioItemState> get sounds => mixerSounds.values.toList();

  @override
  List<AudioItemState> get sounds => _sounds;

  @override
  AudioItemState? get currentSingle => null;

  @override
  List<Object?> get props => [mixerSounds];
}

class AudioSingle extends AudioState {
  final AudioItemState singleSound;

  AudioSingle({required this.singleSound});

  AudioSingle copyWith({AudioItemState? singleSound}) {
    return AudioSingle(singleSound: singleSound ?? this.singleSound);
  }

  @override
  List<AudioItemState> get sounds => [singleSound];

  @override
  AudioItemState? get currentSingle => singleSound;

  AudioSingle toggle() {
    final updated = singleSound.playbackState == PlaybackState.playing
        ? singleSound.copyWith(playbackState: PlaybackState.paused)
        : singleSound.copyWith(playbackState: PlaybackState.playing);
    return AudioSingle(singleSound: updated);
  }

  @override
  List<Object?> get props => [singleSound];
}
