import 'package:equatable/equatable.dart';
import 'package:lull/models/sound_model.dart';
import 'package:lull/services/player_service.dart';

enum PlaybackState { idle, playing, paused }

enum AudioMode { single, mixing }

class AudioItemState extends Equatable {
  final SoundItem sound;
  final double? volume;
  final PlaybackState playbackState;

  const AudioItemState({
    required this.sound,
    this.volume = 0.5,
    required this.playbackState,
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

  /// Whether any sound is actively playing (works for both modes).
  bool get isAnyPlaying;

  /// Pure state transition — no side-effects. Service calls are in AudioNotifier.
  AudioState toggle(SoundItem sound, AudioMode mode);

  Future<AudioState> stop(AudioPlayerService service);

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
  bool get isAnyPlaying => false;

  @override
  AudioState toggle(SoundItem sound, AudioMode mode) {
    if (mode == AudioMode.mixing) {
      return AudioMixing(
        mixerSounds: {
          sound.id: AudioItemState(
            sound: sound,
            playbackState: PlaybackState.playing,
            volume: 0.5,
          ),
        },
      );
    }
    return AudioSingle(
      singleSound: AudioItemState(
        sound: sound,
        playbackState: PlaybackState.playing,
        volume: 0.5,
      ),
    );
  }

  @override
  Future<AudioState> stop(AudioPlayerService service) async {
    await service.stopAll();
    return AudioIdle();
  }

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

  @override
  List<AudioItemState> get sounds => _sounds;

  @override
  AudioItemState? get currentSingle => null;

  @override
  bool get isAnyPlaying =>
      mixerSounds.values.any((s) => s.playbackState == PlaybackState.playing);

  @override
  AudioState toggle(SoundItem sound, AudioMode mode) {
    final updated = Map<String, AudioItemState>.from(mixerSounds);

    if (mixerSounds.containsKey(sound.id)) {
      updated.remove(sound.id);
      return updated.isEmpty ? AudioIdle() : AudioMixing(mixerSounds: updated);
    }

    updated[sound.id] = AudioItemState(
      sound: sound,
      playbackState: PlaybackState.playing,
      volume: 0.5,
    );
    return AudioMixing(mixerSounds: updated);
  }

  @override
  Future<AudioState> stop(AudioPlayerService service) async {
    await service.stopAllMulti();
    return AudioIdle();
  }

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

  @override
  bool get isAnyPlaying => singleSound.playbackState == PlaybackState.playing;

  @override
  AudioState toggle(SoundItem sound, AudioMode mode) {
    if (singleSound.sound.id != sound.id) {
      return AudioSingle(
        singleSound: AudioItemState(
          sound: sound,
          playbackState: PlaybackState.playing,
          volume: 0.5,
        ),
      );
    }

    final isPlaying = singleSound.playbackState == PlaybackState.playing;
    return copyWith(
      singleSound: singleSound.copyWith(
        playbackState: isPlaying ? PlaybackState.paused : PlaybackState.playing,
      ),
    );
  }

  @override
  Future<AudioState> stop(AudioPlayerService service) async {
    await service.stopSingle();
    return AudioIdle();
  }

  @override
  List<Object?> get props => [singleSound];
}
