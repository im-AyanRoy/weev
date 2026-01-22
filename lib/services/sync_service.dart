import '../core/platform_registry.dart';
import '../services/config_service.dart';

class SyncService {
  static Future<void> syncAll() async {
    final config = await ConfigService.load();

    for (final platform in config.platforms.keys) {
      if (!PlatformRegistry.platforms.containsKey(platform)) continue;

      // Adapter-based syncing comes next
    }
  }
}

