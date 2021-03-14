import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/ui/screen/register_screen/register_screen.dart';
import 'package:yes_order/module_auth/ui/states/register_states/register_state.dart';
import 'package:flutter/material.dart';

class RegisterStateSuccess extends RegisterState {
  RegisterStateSuccess(RegisterScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: double.maxFinite,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/images/icon.png',width: 250,),
            ),
          ),
             Center(
               child: Padding(
                 padding: const EdgeInsets.all(25.0),
                 child: Text('${S.of(context).registerSucces}',style: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Colors.grey,
                 ),textAlign: TextAlign.center,),
               ),
             ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 45,
              width: double.maxFinite,
              child: RaisedButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  screen.moveToNext();
                },
                child: Text(
                  '${S.of(context).continues}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  
  }
}
