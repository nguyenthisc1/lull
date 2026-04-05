// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

abstract class AudioPlayerService {
  Future<void> resumeMulti(String id);
  Future<void> resumeSingle();
  Future<void> playMulti(String id, String assetPath, {double volume = 0.5});
  Future<void> playSingle(String id, String assetPath, {double volume = 0.5});
  Future<void> stopMulti(String id);
  Future<void> stopAllMulti();
  Future<void> disposeAllMulti();
  Future<void> disposeSingle();
  Future<void> pauseSingle();
  Future<void> stopSingle();
  void setMultiVolume(String id, double volume);
  void setSingleVolume(double volume);
  Future<void> stopAll();
}

class AudioPlayerServiceImpl implements AudioPlayerService {
  final Map<String, AudioPlayer> _multiPlayers = {};
  AudioPlayer? _singlePlayer;

  @override
  Future<void> resumeMulti(String id) async {
    final player = _multiPlayers[id];
    if (player != null && player.playing == false) {
      await player.play();
    }
  }

  @override
  Future<void> resumeSingle() async {
    final player = _singlePlayer;
    if (player != null && player.playing == false) {
      await player.play();
    }
  }

  @override
  Future<void> playMulti(
    String id,
    String assetPath, {
    double volume = 0.5,
  }) async {
    try {
      _multiPlayers[id] ??= AudioPlayer();
      final player = _multiPlayers[id];
      if (player != null) {
        await player.setAsset(assetPath);
        await player.setLoopMode(LoopMode.all);
        await player.setVolume(volume);
        await player.play();
      }
    } catch (e) {
      final player = _multiPlayers[id];
      if (player != null) {
        await player.dispose();
        _multiPlayers.remove(id);
      }
      print("AudioPlayerServiceImpl (playMulti): $e");
    }
  }

  @override
  Future<void> playSingle(
    String id,
    String assetPath, {
    double volume = 0.5,
  }) async {
    try {
      _singlePlayer ??= AudioPlayer();

      await _singlePlayer!.setAsset(assetPath);
      await _singlePlayer!.setLoopMode(LoopMode.all);
      await _singlePlayer!.setVolume(volume);

      await _singlePlayer!.play();
    } catch (e) {
      await _singlePlayer?.dispose();
      _singlePlayer = null;
      print("AudioPlayerServiceImpl (playSingle): $e");
    }
  }

  @override
  Future<void> stopMulti(String id) async {
    final player = _multiPlayers[id];
    if (player != null) {
      await player.stop();
    }
  }

  @override
  Future<void> stopAllMulti() async {
    for (var player in _multiPlayers.values) {
      await player.stop();
    }
  }

  @override
  Future<void> disposeAllMulti() async {
    for (var player in _multiPlayers.values) {
      await player.dispose();
    }
    _multiPlayers.clear();
  }

  @override
  Future<void> disposeSingle() async {
    if (_singlePlayer != null) {
      await _singlePlayer!.dispose();
      _singlePlayer = null;
    }
  }

  @override
  Future<void> pauseSingle() async {
    await _singlePlayer?.pause();
  }

  @override
  Future<void> stopSingle() async {
    await _singlePlayer?.stop();
  }

  @override
  void setMultiVolume(String id, double volume) {
    _multiPlayers[id]?.setVolume(volume);
  }

  @override
  void setSingleVolume(double volume) {
    _singlePlayer?.setVolume(volume);
  }

  @override
  Future<void> stopAll() async {
    await disposeAllMulti();
    await stopSingle();
  }
}
