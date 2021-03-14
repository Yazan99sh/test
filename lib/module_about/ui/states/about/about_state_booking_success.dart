import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/states/about/about_state.dart';
import 'package:flutter/material.dart';

class AboutStatePageOwnerBookingSuccess extends AboutState {
  AboutStatePageOwnerBookingSuccess(AboutScreenStateManager screenState) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(child: Image.asset('assets/images/succes.png')),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text(S.of(context).weWillContactYouSoon, style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
        ),
          Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  height: 45,
                  width: double.maxFinite,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      screenState.moveToWelcome();
                    },
                    child: Text('Back'),
                    textColor: Colors.white,
                  ),
                ),
              )
            
      ],
    );
  }
}
