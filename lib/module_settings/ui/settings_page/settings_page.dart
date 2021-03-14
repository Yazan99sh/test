import 'package:flutter/material.dart';
import 'package:yes_order/module_about/about_routes.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:yes_order/module_init/init_routes.dart';
import 'package:yes_order/module_notifications/service/fire_notification_service/fire_notification_service.dart';
import 'package:yes_order/module_profile/request/profile/profile_request.dart';
import 'package:yes_order/module_profile/response/profile_response.dart';
import 'package:yes_order/module_profile/service/profile/profile.service.dart';
import 'package:inject/inject.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/service/auth_service/auth_service.dart';
import 'package:yes_order/module_localization/service/localization_service/localization_service.dart';
import 'package:yes_order/module_theme/service/theme_service/theme_service.dart';
import 'package:yes_order/module_auth/enums/user_type.dart';

@provide
class SettingsScreen extends StatefulWidget {
  final AuthService _authService;
  final LocalizationService _localizationService;
  final AppThemeDataService _themeDataService;
  final ProfileService _profileService;
  final FireNotificationService _notificationService;

  SettingsScreen(
    this._authService,
    this._localizationService,
    this._themeDataService,
    this._profileService,
    this._notificationService,
  );

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
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
                              Localizations.localeOf(context).toString() == 'en'
                                  ? 6.0
                                  : 0.0,
                          right:
                              Localizations.localeOf(context).toString() == 'en'
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
                  S.of(context).settings,
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
                      Navigator.of(context).pop();
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
          
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16.0, left: 18, right: 18),
              child: Text(
                '${S.of(context).appearance}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (mode) {
              widget._themeDataService.switchDarkMode(mode).then((value) {});
            },
            title: Text('${S.of(context).darkMode}'),
            secondary: Theme.of(context).brightness != Brightness.dark
                ? Icon(Icons.wb_sunny)
                : Icon(Icons.nights_stay),
          ),
          ListTile(
            title: Text('${S.of(context).language}'),
            leading: Icon(Icons.language),
            trailing: DropdownButton(
                underline: Opacity(
                  opacity: 0.0,
                  child: Container(),
                ),
                value: Localizations.localeOf(context).toString(),
                items: [
                  DropdownMenuItem(
                    child: Text('العربية'),
                    value: 'ar',
                  ),
                  DropdownMenuItem(
                    child: Text('English'),
                    value: 'en',
                  ),
                ],
                onChanged: (String newLang) {
                  widget._localizationService.setLanguage(newLang);
                }),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16.0, left: 18, right: 18),
              child: Text(
                '${S.of(context).account}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: widget._authService.userRole,
            builder: (BuildContext context, AsyncSnapshot<UserRole> snapshot) {
              if (snapshot.data == UserRole.ROLE_OWNER) {
                return ListTile(
                  title: Text('${S.of(context).renewSubscription}'),
                  leading: Icon(Icons.autorenew),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(InitAccountRoutes.INIT_ACCOUNT_SCREEN);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          FutureBuilder(
            future: _getCaptainStateSwitch(),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else {
                return Container();
              }
            },
          ),
          FutureBuilder(
            future: widget._authService.isLoggedIn,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data) {
                return ListTile(
                  title: Text('${S.of(context).signOut}'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    widget._authService.logout().then((value) {
                      Navigator.pushNamedAndRemoveUntil(context,
                          AuthorizationRoutes.LOGIN_SCREEN, (route) => false);
                    });
                  },
                );
              } else {
                return ListTile(
                  title: Text('${S.of(context).login}'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AuthorizationRoutes.LOGIN_SCREEN);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> _getCaptainStateSwitch() async {
    var userRole = await widget._authService.userRole;
    print('${userRole}');
    if (userRole == UserRole.ROLE_OWNER) {
      return Container();
    } else {
      // The User is a captain
      var profile = await widget._profileService.getProfile();
      return SwitchListTile(
        value: profile.isOnline == true,
        onChanged: (bool value) {
          widget._notificationService.setCaptainActive(value);
          widget._profileService.updateCaptainProfile(
            ProfileRequest(
              name: profile.name,
              image: profile.image,
              phone: profile.phone,
              drivingLicence: profile.drivingLicence,
              city: 'Jedda',
              branch: '-1',
              car: profile.car,
              age: profile.age.toString(),
              isOnline: value == true ? 'active' : 'inactive',
            ),
          );
          setState(() {
          });
        },
        title: Text('${S.of(context).myStatus}'),
        secondary: profile.isOnline == true
            ? Icon(Icons.wifi)
            : Icon(Icons.wifi_off),
      );
    }
  }
}
