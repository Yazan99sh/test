import 'package:yes_order/abstracts/module/yes_module.dart';
import 'package:yes_order/module_profile/profile_routes.dart';
import 'package:yes_order/module_profile/ui/screen/activity_screen/activity_screen.dart';
import 'package:yes_order/module_profile/ui/screen/edit_profile/edit_profile.dart';
import 'package:inject/inject.dart';

@provide
class ProfileModule {
  final ActivityScreen activityScreen;
  final EditProfileScreen editProfileScreen;

  ProfileModule(this.activityScreen, this.editProfileScreen) {
    YesModule.RoutesMap.addAll({
      ProfileRoutes.ACTIVITY_SCREEN: (context) => activityScreen,
      ProfileRoutes.EDIT_ACTIVITY_SCREEN: (context) => editProfileScreen,
    });
  }
}
