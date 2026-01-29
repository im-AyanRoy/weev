import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import '../../models/platform_stats.dart';

class InterviewBitStatsService {
  static Future<PlatformStats> fetch(String username) async {
    final url = Uri.parse(
      'https://www.interviewbit.com/profile/$username/',
    );

    final res = await http.get(
      url,
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    if (res.statusCode != 200) {
      throw Exception('InterviewBit profile not found');
    }

    final document = parse(res.body);

    int problemsSolved = 0;
    String globalRank = '-';
    String timeSpent = '-';

    // InterviewBit stats appear in stat cards
    for (final card in document.querySelectorAll('div')) {
      final text = card.text.replaceAll('\n', ' ').trim();

      if (text.contains('Total Problems Solved')) {
        final match = RegExp(r'(\d+)').firstMatch(text);
        if (match != null) {
          problemsSolved = int.parse(match.group(1)!);
        }
      }

      if (text.contains('Global Rank')) {
        final match = RegExp(r'#?(\d+)').firstMatch(text);
        if (match != null) {
          globalRank = match.group(1)!;
        }
      }

      if (text.contains('Time Spent')) {
        final match =
            RegExp(r'(\d+\s*hours?)').firstMatch(text);
        if (match != null) {
          timeSpent = match.group(1)!;
        }
      }
    }

    return PlatformStats(
      platform: 'interviewbit',
      data: {
        'Problems Solved': problemsSolved,
        'Global Rank': globalRank,
        'Time Spent': timeSpent,
      },
    );
  }
}

