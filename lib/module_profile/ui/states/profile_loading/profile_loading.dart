import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_profile/ui/screen/edit_profile/edit_profile.dart';
import 'package:yes_order/module_profile/ui/states/profile_state/profile_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileStateLoading extends ProfileState {
  ProfileStateLoading(EditProfileScreenState screenState) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                ),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 35,
                        height: 35,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Container(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          S.of(context).loading,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  
  }
}
