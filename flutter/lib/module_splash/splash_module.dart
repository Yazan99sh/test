import 'package:yes_order/abstracts/module/yes_module.dart';
import 'package:yes_order/module_splash/splash_routes.dart';
import 'package:yes_order/module_splash/ui/screen/splash_screen.dart';
import 'package:inject/inject.dart';

@provide
class SplashModule extends YesModule {
  SplashModule(SplashScreen splashScreen) {
    YesModule.RoutesMap.addAll({
      SplashRoutes.SPLASH_SCREEN: (context) => splashScreen
    });
  }
}