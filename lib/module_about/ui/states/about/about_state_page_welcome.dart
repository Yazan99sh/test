import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/states/about/about_state.dart';
import 'package:yes_order/module_auth/enums/user_type.dart';
import 'package:flutter/material.dart';

class AboutStatePageWelcome extends AboutState {
  int currentPage = 0;
  final pageController = PageController(initialPage: 0);

  AboutStatePageWelcome(AboutScreenStateManager screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return SafeArea(
      top: true,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.maxFinite,
              child: Text(
                '${S.of(context).welcome} !',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
                      child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                'assets/images/welcom.png',
              ),
                  )),
          ),
          Expanded(
              child:
                  Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              '${S.of(context).whoAreYou} ?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25, right: 25, left: 25, bottom: 16),
              child: Container(
                width: double.maxFinite,
                height: 45,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    screenState.moveNext(UserRole.ROLE_OWNER);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('${S.of(context).storeOwner}'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, bottom: 16),
              child: Container(
                width: double.maxFinite,
                height: 45,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    screenState.moveNext(UserRole.ROLE_CAPTAIN);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                  child: Text(
                    '${S.of(context).captain}',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
