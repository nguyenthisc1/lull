import 'package:equatable/equatable.dart';

class LibrarySoundEntry extends Equatable {
  final String soundId;
  final double volume;

  const LibrarySoundEntry({required this.soundId, required this.volume});

  Map<String, dynamic> toJson() => {'soundId': soundId, 'volume': volume};

  factory LibrarySoundEntry.fromJson(Map<String, dynamic> json) =>
      LibrarySoundEntry(
        soundId: json['soundId'] as String,
        volume: (json['volume'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [soundId, volume];
}

class LibraryItem extends Equatable {
  final String id;
  final String name;
  final List<LibrarySoundEntry> sounds;
  final int? timerSeconds;
  final DateTime createdAt;

  const LibraryItem({
    required this.id,
    required this.name,
    required this.sounds,
    this.timerSeconds,
    required this.createdAt,
  });

  LibraryItem copyWith({
    String? id,
    String? name,
    List<LibrarySoundEntry>? sounds,
    int? timerSeconds,
    DateTime? createdAt,
  }) {
    return LibraryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sounds: sounds ?? this.sounds,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sounds': sounds.map((s) => s.toJson()).toList(),
    'timerSeconds': timerSeconds,
    'createdAt': createdAt.toIso8601String(),
  };

  factory LibraryItem.fromJson(Map<String, dynamic> json) => LibraryItem(
    id: json['id'] as String,
    name: json['name'] as String,
    sounds: (json['sounds'] as List<dynamic>)
        .map((e) => LibrarySoundEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
    timerSeconds: json['timerSeconds'] as int?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  @override
  List<Object?> get props => [id, name, sounds, timerSeconds, createdAt];
}
