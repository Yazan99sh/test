import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_profile/request/profile/profile_request.dart';
import 'package:yes_order/module_profile/state_manager/edit_profile/edit_profile.dart';
import 'package:yes_order/module_profile/ui/states/profile_loading/profile_loading.dart';
import 'package:yes_order/module_profile/ui/states/profile_state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

@provide
class EditProfileScreen extends StatefulWidget {
  final EditProfileStateManager _stateManager;

  EditProfileScreen(this._stateManager);

  @override
  State<StatefulWidget> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  List<ProfileState> states = [];

  void saveProfile(ProfileRequest request) {
    widget._stateManager.submitProfile(this, request);
  }

  void uploadImage(ProfileRequest request) {
    widget._stateManager.uploadImage(this, request);
  }

  void editProfile() {
    widget._stateManager.editProfile(this);
  }

  void getProfile() {
    widget._stateManager.getProfile(this);
  }

  @override
  void initState() {
    widget._stateManager.stateStream.listen((event) {
      states.add(event);
      if (mounted) {
        setState(() {});
      }
    });
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (states.isEmpty) {
      states.add(ProfileStateLoading(this));
    }
    if (states.last is ProfileStateLoading) {
      return states.last.getUI(context);
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              SafeArea(
                top: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left:
                                  Localizations.localeOf(context).toString() ==
                                          'en'
                                      ? 6.0
                                      : 0.0,
                              right:
                                  Localizations.localeOf(context).toString() ==
                                          'en'
                                      ? 0.0
                                      : 6.0,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      S.of(context).myProfile,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                        
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              states.last.getUI(context),
            ],
          ),
        ),
      );
    }
  }
}
