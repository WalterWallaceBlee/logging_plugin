
import 'logging_plugin_platform_interface.dart';

class LoggingPlugin {
  Future<String?> getPlatformVersion() {
    return LoggingPluginPlatform.instance.getPlatformVersion();
  }
}











