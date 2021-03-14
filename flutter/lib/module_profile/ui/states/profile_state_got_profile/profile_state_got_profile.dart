import 'package:yes_order/module_profile/request/profile/profile_request.dart';
import 'package:yes_order/module_profile/ui/screen/edit_profile/edit_profile.dart';
import 'package:yes_order/module_profile/ui/states/profile_state/profile_state.dart';
import 'package:yes_order/module_profile/ui/widget/profile_form/profile.dart';
import 'package:yes_order/module_profile/ui/widget/profile_form/profile_form.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileStateGotProfile extends ProfileState {
  ProfileRequest request;

  ProfileStateGotProfile(
      EditProfileScreenState screenState, this.request)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return ProfileWidget(
      updateProfile: () {
        screenState.editProfile();
      },
      request: request,
    );
  }
}
