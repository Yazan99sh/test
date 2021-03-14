import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_profile/ui/screen/edit_profile/edit_profile.dart';
import 'package:yes_order/module_profile/ui/states/profile_state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileStateSaveSuccess extends ProfileState {
  ProfileStateSaveSuccess(EditProfileScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/succes.png')),
          Text(
            S.of(context).saveSuccess,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              width: double.maxFinite,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                onPressed: () {
                  screenState.getProfile();
                },
                child: Text(
                  S.of(context).next,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
