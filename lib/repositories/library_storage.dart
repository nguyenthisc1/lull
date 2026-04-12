import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/library_model.dart';

abstract final class LibraryStorage {
  static const _kKey = 'saved_libraries';

  static Future<List<LibraryItem>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => LibraryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(LibraryItem item) async {
    final items = await loadAll();
    final updated = [...items, item];
    await _persist(updated);
  }

  static Future<void> update(LibraryItem item) async {
    final items = await loadAll();
    final updated = items.map((e) => e.id == item.id ? item : e).toList();
    await _persist(updated);
  }

  static Future<void> delete(String id) async {
    final items = await loadAll();
    final updated = items.where((e) => e.id != id).toList();
    await _persist(updated);
  }

  static Future<void> _persist(List<LibraryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kKey, json);
  }
}
