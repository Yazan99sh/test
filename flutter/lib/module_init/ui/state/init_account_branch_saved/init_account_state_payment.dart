import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_init/ui/screens/init_account_screen/init_account_screen.dart';
import 'package:yes_order/module_init/ui/state/init_account/init_account.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InitAccountStatePayment extends InitAccountState {
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();

  InitAccountStatePayment(InitAccountScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FaIcon(FontAwesomeIcons.ccVisa, size: 140),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).ourBankName,style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).ourBankAccountNumber,style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(S.of(context).next),
                  onPressed: () {
                    screen.moveToOrders();
                  }),
            ),
          )
        ],
      ),
    );
  }
}
