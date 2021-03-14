import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_init/ui/screens/init_account_screen/init_account_screen.dart';
import 'package:yes_order/module_init/ui/state/init_account/init_account.state.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class InitAccountStateProfileCreated extends InitAccountState {
  InitAccountStateProfileCreated(InitAccountScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Lottie.asset('assets/animations/register-success.json'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              width: double.maxFinite,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(S.of(context).paySubscription),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        OrdersRoutes.CAPTAIN_ORDERS_SCREEN, (r) => false);
                  }),
            ),
          )
        ],
      ),
    );
  }

}