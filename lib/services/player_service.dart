// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final Map<String, AudioPlayer> _players = {};

  Future<void> resume(String id) async {
    final player = _players[id];
    if (player != null) {
      await player.play();
    }
  }

  Future<void> newPlaySound(
    String id,
    String assetPath, {
    double volume = 0.5,
  }) async {
    if (_players.containsKey(id)) {
      await _players[id]?.stop();
      await _players[id]?.dispose();
      _players.remove(id);
    }

    AudioPlayer player = AudioPlayer();
    try {
      await player.setAsset(assetPath);
      await player.setLoopMode(LoopMode.all);
      await player.setVolume(volume);
      _players[id] = player;
      await player.play();
    } catch (e) {
      _players.remove(id);
      player.dispose();
      print("AudioPlayerService (newPlaySound): $e");
    }
  }

  Future<void> stop(String id) async {
    final player = _players[id];
    if (player != null) {
      await player.stop();
    }
  }

  void setVolume(String id, double volume) {
    _players[id]?.setVolume(volume);
  }

  void stopAll() {
    for (var player in _players.values) {
      player.stop();
      player.dispose();
    }
    _players.clear();
  }
}
