import '../base/platform_adapter.dart';
import '../../models/activity.dart';
import 'codechef_scraper.dart';

class CodeChefAdapter extends PlatformAdapter {
  @override
  String get name => 'codechef';

  @override
  Future<List<Activity>> fetchActivity(
    String username,
  ) async {
    final stats =
        await CodeChefScraper.fetchStats(username);

    return [
      Activity(
        DateTime.now(),
        'codechef_rating',
        stats['Rating'] ?? 0,
      ),
    ];
  }
}