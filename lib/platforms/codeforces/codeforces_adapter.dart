import '../base/platform_adapter.dart';
import '../../models/activity.dart';
import 'codeforces_api.dart';

class CodeforcesAdapter extends PlatformAdapter {
  @override
  String get name => 'codeforces';

  @override
  Future<List<Activity>> fetchActivity(String username) async {
    final submissions =
        await CodeforcesApi.getSubmissions(username);

    // Placeholder aggregation
    return submissions.isEmpty ? [] : [];
  }
}

