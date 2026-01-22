import '../base/platform_adapter.dart';
import '../../models/activity.dart';

class LeetCodeAdapter extends PlatformAdapter {
  @override
  String get name => 'leetcode';

  @override
  Future<List<Activity>> fetchActivity(String username) async {
    // To be implemented using GraphQL later
    return [];
  }
}

