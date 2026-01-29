import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

Map<String, dynamic>? extractEmbeddedProfileJson(String html) {
  final match = RegExp(
    r'window\.__INITIAL_STATE__\s*=\s*({.*?});',
    dotAll: true,
  ).firstMatch(html);

  if (match == null) return null;

  try {
    return jsonDecode(match.group(1)!);
  } catch (_) {
    return null;
  }
}

class CodeChefScraper {
  static Future<Map<String, dynamic>> fetchStats(
    String username,
  ) async {
    final url = 'https://www.codechef.com/users/$username';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; weev-cli)',
      },
    );

    final embedded =
        extractEmbeddedProfileJson(res.body);

    if (embedded != null) {
      Map<String, dynamic> user = {};

      if (embedded['profile'] is Map) {
        user = embedded['profile'];
      } else if (embedded['user'] is Map) {
        user = embedded['user'];
      } else if (embedded['data'] is Map &&
          embedded['data']['profile'] is Map) {
        user = embedded['data']['profile'];
      }

      // Try multiple possible key names
      int pickInt(List<String> keys) {
        for (final k in keys) {
          if (user[k] is int) return user[k];
          if (user[k] is String) {
            final v =
                int.tryParse(user[k].replaceAll(RegExp(r'[^0-9]'), ''));
            if (v != null) return v;
          }
        }
        return 0;
      }

      return {
        'Rating': pickInt(['rating', 'currentRating']),
        'Max Rating': pickInt(['maxRating', 'highestRating']),
        'Stars': user['stars'] ??
            user['ratingStar'] ??
            'N/A',
        'Global Rank': pickInt(
            ['globalRank', 'global_rank']),
        'Country Rank': pickInt(
            ['countryRank', 'country_rank', 'indiaRank']),
        'Problems Solved': pickInt(
            ['problemsSolved', 'totalSolved', 'fullySolved']),
      };
    }

    if (res.statusCode != 200) {
      throw Exception('CodeChef profile not found');
    }

    final doc = parser.parse(res.body);

    // ---------------- HELPERS ----------------

    int extractIntBySelector(String selector) {
      final el = doc.querySelector(selector);
      if (el == null) return 0;
      return int.tryParse(
            el.text.replaceAll(RegExp(r'[^0-9]'), ''),
          ) ??
          0;
    }

    String extractTextBySelector(String selector) {
      return doc.querySelector(selector)?.text.trim() ?? 'N/A';
    }

    int extractRankFromStatsGrid(String labelKeyword) {
      // CodeChef profile stats are rendered as label-value pairs
      final rows = doc.querySelectorAll('section div');

      for (int i = 0; i < rows.length - 1; i++) {
        final label = rows[i].text.trim().toLowerCase();
        final value = rows[i + 1].text.trim();

        if (label.contains(labelKeyword)) {
          final match = RegExp(r'#?\s*(\d+)').firstMatch(value);
          if (match != null) {
            return int.parse(match.group(1)!);
          }
        }
      }
      return 0;
    }

    int extractSolvedCount() {
      // Explicitly look for "Problems Solved" / "Fully Solved" labels
      final rows = doc.querySelectorAll('section div');

      for (int i = 0; i < rows.length - 1; i++) {
        final label = rows[i].text.trim().toLowerCase();
        final value = rows[i + 1].text.trim();

        if (label.contains('problems solved') ||
            label.contains('fully solved')) {
          final match = RegExp(r'(\d+)').firstMatch(value);
          if (match != null) {
            return int.parse(match.group(1)!);
          }
        }
      }
      return 0;
    }

    // ---------------- RETURN ----------------

    return {
      'Rating': extractIntBySelector('.rating-number'),
      'Max Rating': extractIntBySelector('.rating-header small'),
      'Stars': extractTextBySelector('.rating-star'),
      'Global Rank': extractRankFromStatsGrid('global'),
      'Country Rank': extractRankFromStatsGrid('india'),
      'Problems Solved': extractSolvedCount(),
    };
  }
}