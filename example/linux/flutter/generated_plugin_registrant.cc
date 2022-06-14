//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <logging_plugin/logging_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) logging_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "LoggingPlugin");
  logging_plugin_register_with_registrar(logging_plugin_registrar);
}
