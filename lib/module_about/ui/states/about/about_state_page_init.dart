import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/states/about/about_state.dart';
import 'package:yes_order/module_auth/enums/user_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:yes_order/module_about/ui/widgets/languageButton.dart';

@provide
class AboutStatePageInit extends AboutState {
  @override
  AboutScreenStateManager screenState;
  String currentLanguage;
  UserRole currentRole;

  AboutStatePageInit(this.screenState) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: Image.asset(
              'assets/images/translate.png',
              width: 75,
              height: 75,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text('${S.of(context).preferredLanguage}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('${S.of(context).selectLanguage}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //rgb(236,239,241)
              color: Color.fromRGBO(236, 239, 241, 1),
            ),
            child: Column(
              children: [
                Container(
                  height: 18,
                ),
                InkWell(
                  onTap: () {
                    screenState.setLanguage('en');
                  },
                  child: LanguageButton(
                    flag: 'united-kingdom.png',
                    textLang: 'English',
                    currentLanguage: _getCurrentLanguage(context),
                  ),
                ),
                Container(
                  height: 18,
                ),
                InkWell(
                  onTap: () {
                    screenState.setLanguage('ar');
                  },
                  child: LanguageButton(
                    flag: 'syria.png',
                    textLang: 'العربية',
                    currentLanguage: _getCurrentLanguage(context),
                  ),
                ),
                Container(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 45,
            width: double.maxFinite,
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              //rgb(33,150,243)
              color: Colors.blue,
              child: Text('${S.of(context).next}'),
              onPressed: () {
                screenState.moveToWelcome();
              },
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _getCurrentLanguage(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    if (myLocale.toString() == 'en') {
      return 'English';
    } else if (myLocale.toString() == 'ar') {
      return 'العربية';
    } else {
      return myLocale.toString();
    }
  }

  String _getCurrentRole(BuildContext context) {
    if (currentRole == UserRole.ROLE_OWNER) {
      return S.of(context).storeOwner;
    } else if (currentRole == UserRole.ROLE_CAPTAIN) {
      return S.of(context).captain;
    } else {
      return S.of(context).andIAm;
    }
  }

  void _showLanguagePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 42,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  Text(S.of(context).language),
                  Text('English'),
                  Text('العربية'),
                ],
                onSelectedItemChanged: (lang) {
                  if (lang > 0) {
                    currentLanguage = lang == 2 ? 'ar' : 'en';
                    screenState.setLanguage(lang == 2 ? 'ar' : 'en');
                  }
                },
              ),
            ));
  }

  void _showRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 42,
          scrollController: FixedExtentScrollController(initialItem: 1),
          children: [
            Text(S.of(context).andIAm),
            Text(S.of(context).captain),
            Text(S.of(context).storeOwner),
          ],
          onSelectedItemChanged: (type) {
            if (type > 0) {
              currentRole =
                  type == 1 ? UserRole.ROLE_CAPTAIN : UserRole.ROLE_OWNER;
              screenState.refresh(this);
            }
          },
        ),
      ),
    );
  }
}
// _showLanguagePicker(context);
//_showRolePicker
// moveNext
