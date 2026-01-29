import 'dart:convert';
import 'dart:io';

class HackerRankStore {
  static String get _path {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!;
    return '$home/.weev/hackerrank.json';
  }

  static Future<void> save(Map<String, dynamic> data) async {
    final file = File(_path);
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> load() async {
    final file = File(_path);
    if (!await file.exists()) return null;
    return jsonDecode(await file.readAsString());
  }

  static Future<void> clear() async {
    final file = File(_path);
    if (await file.exists()) await file.delete();
  }
}

