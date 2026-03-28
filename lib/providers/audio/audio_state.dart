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
  @override
  List<AudioItemState> get sounds => [];

  @override
  AudioItemState? get currentSingle => null;

  @override
  List<Object?> get props => [];
}

class AudioMixing extends AudioState {
  final Map<String, AudioItemState> mixerSounds;

  AudioMixing({required this.mixerSounds});

  AudioMixing copyWith({Map<String, AudioItemState>? mixerSounds}) {
    return AudioMixing(mixerSounds: mixerSounds ?? this.mixerSounds);
  }

  @override
  List<AudioItemState> get sounds => mixerSounds.values.toList();

  @override
  AudioItemState? get currentSingle => null;

  @override
  List<Object?> get props => [mixerSounds.entries.toList()];
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

  @override
  List<Object?> get props => [singleSound];
}
