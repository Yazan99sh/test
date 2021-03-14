import 'package:yes_order/abstracts/module/yes_module.dart';
import 'package:yes_order/module_about/about_routes.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/screen/about_screen/about_screen.dart';
import 'package:inject/inject.dart';

@provide
class AboutModule extends YesModule {
  AboutModule(AboutScreenStateManager aboutScreenStateManager) {
    YesModule.RoutesMap.addAll({
      AboutRoutes.ROUTE_ABOUT: (context) => AboutScreen(aboutScreenStateManager),
    });
  }
}