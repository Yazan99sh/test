import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/ui/screen/register_screen/register_screen.dart';
import 'package:yes_order/module_auth/ui/states/register_states/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RegisterStatePhoneCodeSent extends RegisterState {
  final _confirmationController = TextEditingController();
  bool retryEnabled = false;
  bool loading = false;

  RegisterStatePhoneCodeSent(RegisterScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return Form(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MediaQuery.of(context).viewInsets.bottom == 0
              ? SvgPicture.asset(
                  'assets/images/Authentication-bro.svg',
                  height: 250,
                  width: 250,
                )
              : Container(),
          Center(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${S.of(context).confirmDescribtion} ${screen.number}',style:TextStyle(
              fontWeight: FontWeight.bold
            ),textAlign: TextAlign.center,),
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                 color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
              ),
              child: TextFormField(
                  controller: _confirmationController,
                  decoration: InputDecoration(
                    hintText: '123456',
                    prefixIcon: Icon(Icons.sms),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v.isEmpty) {
                      return S.of(context).pleaseInputPhoneNumber;
                    }
                    return null;
                  }),
            ),
          ),
          OutlinedButton(
            onPressed: retryEnabled
                ? () {
                    screen.retryPhone();
                  }
                : null,
            child: Text(S.of(context).resendCode),
          ),
          Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 45,
                    width: double.maxFinite,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: !loading?() {
                        loading = true;
                        Future.delayed(Duration(seconds: 10), () {
                          loading = false;
                        });
                        screen.refresh();
                        screen.confirmCaptainSMS(_confirmationController.text);
                      }:(){},
                      child: !loading? Text(
                        S.of(context).confirm,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ):Center(child :Container(width:25,height:25,child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),))),
                    ),
                  ),
                ),
        ],
      ),
    );
  
  }
}
