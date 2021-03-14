import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/states/about/about_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AboutStateRequestBooking extends AboutState {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;
  AboutStateRequestBooking(AboutScreenStateManager screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    final node = FocusScope.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: [
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/request_booking.png',
                        width: 250,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 16, bottom: 8),
                child: SafeArea(
                  top: true,
                  child: Text(
                    S.of(context).toFindOutMorePleaseLeaveYourPhonenandWeWill,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: mode,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          child: Text('${S.of(context).phoneNumber}'),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[900]
                                    : Color.fromRGBO(236, 239, 241, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: _phoneController,
                          validator: (phone) {
                            if (phone.isEmpty) {
                              return S.of(context).pleaseInputPhoneNumber;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '+963 959 796 748',
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onEditingComplete: () => node.nextFocus(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 16, bottom: 8, left: 8, right: 8),
                          child: Text('${S.of(context).name}'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[900]
                                  : Color.fromRGBO(236, 239, 241, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (name) {
                              if (name.isEmpty) {
                                return S.of(context).nameIsRequired;
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => node.unfocus(),
                            decoration: InputDecoration(
                              hintText: '${S.of(context).name}',
                              prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      mode = AutovalidateMode.always;
                      screenState.refresh(this);
                      if (_formKey.currentState.validate()) {
                        screenState.createAppointment(
                            _nameController.text, _phoneController.text);
                      } else {
                        screenState.showSnackBar(
                          S.of(context).pleaseCompleteTheForm,
                        );
                      }
                    },
                    child: Text(S.of(context).requestMeeting),
                    textColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: GestureDetector(
                onTap: () {
                  screenState.moveToWelcome();
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Localizations.localeOf(context).toString() == 'en'
                          ? 6.0
                          : 0.0,
                      right: Localizations.localeOf(context).toString() == 'en'
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
          ),
        ),
      ],
    );
  }
}
