import '../../services/config_service.dart';

class StatsCommand {
  static Future<void> run() async {
    final config = await ConfigService.load();

    if (config.platforms.isEmpty) {
      print('No platforms configured. Run `weev init` first.');
      return;
    }

    print('Configured platforms:\n');
    config.platforms.forEach((k, v) {
      print('- $k: $v');
    });
  }
}

