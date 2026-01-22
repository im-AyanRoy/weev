import '../base/platform_adapter.dart';
import '../../models/activity.dart';
import 'github_api.dart';

class GitHubAdapter extends PlatformAdapter {
  @override
  String get name => 'github';

  @override
  Future<List<Activity>> fetchActivity(String username) async {
    // Placeholder: real contribution graph comes later
    await GitHubApi.getUser(username);

    return [];
  }
}

