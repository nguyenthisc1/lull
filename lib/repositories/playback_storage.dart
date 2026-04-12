import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../providers/audio/audio_state.dart';

abstract final class PlaybackStorage {
  static const _kKey = 'last_playback';

  static Future<void> save(AudioState state, AudioMode mode) async {
    if (state is AudioIdle) {
      await clear();
      return;
    }

    final sounds = state.sounds
        .map(
          (item) => {
            'soundId': item.sound.id,
            'volume': item.volume ?? 0.5,
          },
        )
        .toList();

    final json = jsonEncode({'mode': mode.name, 'sounds': sounds});

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, json);
  }

  static Future<PlaybackSnapshot?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final mode = AudioMode.values.firstWhere(
        (e) => e.name == map['mode'],
        orElse: () => AudioMode.single,
      );
      final sounds = (map['sounds'] as List<dynamic>)
          .map(
            (e) => PlaybackSoundEntry(
              soundId: e['soundId'] as String,
              volume: (e['volume'] as num).toDouble(),
            ),
          )
          .toList();
      return PlaybackSnapshot(mode: mode, sounds: sounds);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kKey);
  }
}

class PlaybackSoundEntry {
  final String soundId;
  final double volume;

  const PlaybackSoundEntry({required this.soundId, required this.volume});
}

class PlaybackSnapshot {
  final AudioMode mode;
  final List<PlaybackSoundEntry> sounds;

  const PlaybackSnapshot({required this.mode, required this.sounds});
}
