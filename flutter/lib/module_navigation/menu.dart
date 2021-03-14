import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yes_order/module_profile/profile_routes.dart';
import 'package:yes_order/module_settings/setting_routes.dart';
import 'package:yes_order/generated/l10n.dart';
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ProfileRoutes.EDIT_ACTIVITY_SCREEN);
                },
                leading: Icon(Icons.account_circle_rounded),
                title: Text('${S.of(context).profile}'),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(SettingRoutes.ROUTE_SETTINGS);
                },
                leading: Icon(Icons.settings),
                title: Text('${S.of(context).settings}'),
              ),
              ListTile(
                onTap: () {
                  String url = 'https://yes_order-app.web.app/tos.html';
                  launch(url);
                },
                leading: Icon(Icons.supervised_user_circle),
                title: Text('${S.of(context).termsOfService}'),
              ),
              ListTile(
                onTap: () {
                  String url = 'https://yes_order-app.web.app/privacy.html';
                  launch(url);
                },
                leading: Icon(Icons.privacy_tip),
                title: Text('${S.of(context).privacyPolicy}'),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Yes Soft | App Development'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
