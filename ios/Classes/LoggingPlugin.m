#import "LoggingPlugin.h"
#if __has_include(<logging_plugin/logging_plugin-Swift.h>)
#import <logging_plugin/logging_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "logging_plugin-Swift.h"
#endif

@implementation LoggingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLoggingPlugin registerWithRegistrar:registrar];
}
@end
