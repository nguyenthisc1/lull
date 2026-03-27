// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final Map<String, AudioPlayer> _multiPlayers = {};
  AudioPlayer? _singlePlayer;

  /// Resume a multi player (not start from beginning, but resumes playback).
  Future<void> resumeMulti(String id) async {
    final player = _multiPlayers[id];
    if (player != null && player.playing == false) {
      await player.play();
    }
  }

  Future<void> resumeSingle() async {
    final player = _singlePlayer;
    if (player != null && player.playing == false) {
      await player.play();
    }
  }

  /// Start a multi player sound, or resumes it if already loaded.
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
      print("AudioPlayerService (playMulti): $e");
    }
  }

  /// Start a single player sound, replacing any active single player.
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
      print("AudioPlayerService (playSingle): $e");
    }
  }

  /// Stop a single multi track by id.
  Future<void> stopMulti(String id) async {
    final player = _multiPlayers[id];
    if (player != null) {
      await player.stop();
    }
  }

  /// Stops all multi players, but does not dispose of them.
  Future<void> stopAllMulti() async {
    for (var player in _multiPlayers.values) {
      await player.stop();
    }
  }

  /// Stops and disposes all multi players.
  Future<void> disposeAllMulti() async {
    if (_multiPlayers.isNotEmpty) {
      for (var player in _multiPlayers.values) {
        await player.dispose();
      }
    }
  }

  Future<void> disposeSingle() async {
    if (_singlePlayer != null) {
      await _singlePlayer!.dispose();
    }
  }

  /// Stop and pause the single player.
  Future<void> pauseSingle() async {
    await _singlePlayer?.pause();
  }

  Future<void> stopSingle() async {
    await _singlePlayer?.stop();
  }

  /// Set volume for a specific multi player (by id).
  void setMultiVolume(String id, double volume) {
    _multiPlayers[id]?.setVolume(volume);
  }

  /// Set volume for the single player.
  void setSingleVolume(double volume) {
    _singlePlayer?.setVolume(volume);
  }

  /// Stop and dispose ALL players (both multi and single).
  Future<void> stopAll() async {
    await disposeAllMulti();
    await stopSingle();
  }
}
