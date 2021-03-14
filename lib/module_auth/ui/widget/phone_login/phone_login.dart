import 'package:yes_order/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhoneLoginWidget extends StatefulWidget {
  final Function(String) onLoginRequested;
  final Function() onRetry;
  final Function(String) onConfirm;
  final bool codeSent;

  PhoneLoginWidget({
    this.onLoginRequested,
    this.onConfirm,
    this.onRetry,
    this.codeSent,
  });

  @override
  State<StatefulWidget> createState() => _PhoneLoginWidgetState();
}

class _PhoneLoginWidgetState extends State<PhoneLoginWidget> {
  String _errorMsg;
  Scaffold pageLayout;
  bool loading = false;

  final GlobalKey _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String countryCode = '+963';

  bool retryEnabled = false;
  String hint = '912 345 678';
  @override
  Widget build(BuildContext context) {
    if (loading) {
      Future.delayed(Duration(seconds: 10)).then((value) {
        loading = false;
        if (mounted) {
          setState(() {});
        }
      });
    }
    if (countryCode == '+963') {
      hint = '912 345 678';
    } else if (countryCode == '+966') {
      hint = '512 345 678';
    } else {
      hint = '712 345 678';
    }
    return SingleChildScrollView(
      child: Form(
        key: _signUpFormKey,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MediaQuery.of(context).viewInsets.bottom == 0
                ? Container(
                    child: Image.asset(
                    'assets/images/we_deliver.png',
                    width: 250,
                  ))
                : Container(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8,bottom: 50,right:16,left: 16),
                    child: Text('${S.of(context).phoneLogin}',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.center,
                    ),
                  
                  ),
                ),
            Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(right: 132.0, left: 132.0),
                  child: Text(S.of(context).phoneNumber),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  right: 16.0, left: 16, top: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                    ),
                    child: Center(
                      child: DropdownButton(
                        underline: Container(),
                        onChanged: (v) {
                          countryCode = v;
                          if (mounted) setState(() {});
                        },
                        value: countryCode,
                        items: [
                          DropdownMenuItem(
                            value: '+966',
                            child: dropComponent('saudi.svg'),
                          ),
                          DropdownMenuItem(
                            value: '+961',
                            child: dropComponent('lebanon.svg'),
                          ),
                          DropdownMenuItem(
                            value: '+963',
                            child: dropComponent('syria.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]
                              : Color.fromRGBO(236, 239, 241, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: hint,
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 11),
                          ),
                          validator: (v) {
                            if (v.isEmpty) {
                              return S.of(context).pleaseInputPhoneNumber;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Color.fromRGBO(236, 239, 241, 1),
                      ),
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 35,
                              height: 35,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                S.of(context).loading,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          String phone = _phoneController.text;
                          if (phone[0] == '0') {
                            phone = phone.substring(1);
                          }
                          loading = true;
                          setState(() {});
                          widget.onLoginRequested(
                              countryCode + _phoneController.text);
                        },
                        child: Text(
                          S.of(context).sendMeCode,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget dropComponent(String icon) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/$icon',
        width: 25,
      ),
    );
  }
}
