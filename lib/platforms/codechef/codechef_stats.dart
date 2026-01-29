import '../../models/platform_stats.dart';
import 'codechef_scraper.dart';

class CodeChefStatsService {
  static Future<PlatformStats?> fetch(
    String username,
  ) async {
    try {
      final data =
          await CodeChefScraper.fetchStats(username);

      return PlatformStats(
        platform: 'codechef',
        data: data,
      );
    } catch (e) {
      print('⚠️  CodeChef fetch failed: $e');
      return null;
    }
  }
}