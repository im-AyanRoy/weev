import 'dart:convert';
import 'package:http/http.dart' as http;

class HackerRankAdapter {
  static Future<Map<String, dynamic>> fetchStats(String username) async {
    final url = Uri.parse(
      'https://www.hackerrank.com/rest/hackers/$username/profile',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'weev-cli',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('HackerRank user not found');
    }

    final json = jsonDecode(response.body);
    final model = json['model'];

    return {
      'username': model['username'],
      'score': model['score'] ?? 0,
      'badges': (model['badges'] as List<dynamic>?)?.map((b) {
        return {
          'name': b['badge_name'],
          'stars': b['stars'],
        };
      }).toList() ?? [],
    };
  }
}

