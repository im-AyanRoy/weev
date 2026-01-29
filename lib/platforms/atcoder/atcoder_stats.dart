import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/platform_stats.dart';

class AtCoderStatsService {
  static Future<PlatformStats> fetch(String username) async {
    final url = Uri.parse(
      'https://atcoder.jp/users/$username/history/json',
    );

    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('AtCoder user not found');
    }

    final List<dynamic> history = jsonDecode(res.body);

    if (history.isEmpty) {
      return PlatformStats(
        platform: 'atcoder',
        data: {'Message': 'No contests found'},
      );
    }

    final latest = history.last;

    final ratings = history
        .map((e) => e['NewRating'] as int)
        .toList();

    return PlatformStats(
      platform: 'atcoder',
      data: {
        'Current Rating': latest['NewRating'],
        'Highest Rating': ratings.reduce((a, b) => a > b ? a : b),
        'Total Contests': history.length,
        'Last Contest': latest['ContestName'],
      },
    );
  }
}

