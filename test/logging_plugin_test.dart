import 'package:flutter_test/flutter_test.dart';
import 'package:logging_plugin/logging_plugin.dart';
import 'package:logging_plugin/logging_plugin_platform_interface.dart';
import 'package:logging_plugin/logging_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLoggingPluginPlatform 
    with MockPlatformInterfaceMixin
    implements LoggingPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LoggingPluginPlatform initialPlatform = LoggingPluginPlatform.instance;

  test('$MethodChannelLoggingPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLoggingPlugin>());
  });

  test('getPlatformVersion', () async {
    LoggingPlugin loggingPlugin = LoggingPlugin();
    MockLoggingPluginPlatform fakePlatform = MockLoggingPluginPlatform();
    LoggingPluginPlatform.instance = fakePlatform;
  
    expect(await loggingPlugin.getPlatformVersion(), '42');
  });
}
