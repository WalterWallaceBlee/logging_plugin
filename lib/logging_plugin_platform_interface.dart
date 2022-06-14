import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'logging_plugin_method_channel.dart';

abstract class LoggingPluginPlatform extends PlatformInterface {
  /// Constructs a LoggingPluginPlatform.
  LoggingPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LoggingPluginPlatform _instance = MethodChannelLoggingPlugin();

  /// The default instance of [LoggingPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelLoggingPlugin].
  static LoggingPluginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LoggingPluginPlatform] when
  /// they register themselves.
  static set instance(LoggingPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
