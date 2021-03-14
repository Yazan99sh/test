import 'package:yes_order/abstracts/module/yes_module.dart';
import 'package:yes_order/module_settings/setting_routes.dart';
import 'package:yes_order/module_settings/ui/settings_page/settings_page.dart';
import 'package:inject/inject.dart';

@provide
class SettingsModule extends YesModule {
  final SettingsScreen _settingsScreen;

  SettingsModule(this._settingsScreen) {
    YesModule.RoutesMap.addAll({
      SettingRoutes.ROUTE_SETTINGS: (context) => _settingsScreen
    });
  }
}