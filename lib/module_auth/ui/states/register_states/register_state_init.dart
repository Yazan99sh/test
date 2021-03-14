import 'package:yes_order/module_auth/enums/user_type.dart';
import 'package:yes_order/module_auth/ui/screen/register_screen/register_screen.dart';
import 'package:yes_order/module_auth/ui/states/register_states/register_state.dart';
import 'package:yes_order/module_auth/ui/widget/email_password_register/email_password_register.dart';
import 'package:yes_order/module_auth/ui/widget/phone_login/phone_login.dart';
import 'package:yes_order/module_auth/ui/widget/user_type_selector/user_type_selector.dart';
import 'package:flutter/material.dart';

class RegisterStateInit extends RegisterState {
  UserRole userType = UserRole.ROLE_OWNER;
  final registerTypeController =
      PageController(initialPage: UserRole.ROLE_OWNER.index);
  bool loading = false;

  RegisterStateInit(RegisterScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 96,
          child: UserTypeSelector(
            currentUserType: screen.currentUserRole ?? userType,
            onUserChange: (newType) {
              userType = newType;
              screen.currentUserRole = newType;
              screen.refresh();
              registerTypeController.animateToPage(
                userType.index,
                curve: Curves.linear,
                duration: Duration(milliseconds: 350),
              );
            },
          ),
        ),
        Expanded(
            child: PageView(
          controller: registerTypeController,
          onPageChanged: (pos) {
            userType = UserRole.values[pos];
            screen.currentUserRole = UserRole.values[pos];
            screen.refresh();
          },
          children: [
            PhoneLoginWidget(
              codeSent: false,
              onLoginRequested: (phone) {
                loading = true;
                screen.refresh();
                screen.registerCaptain(phone);
              },
              onConfirm: (confirmCode) {
                loading = true;
                screen.refresh();
                screen.confirmCaptainSMS(confirmCode);
              },
            ),
            EmailPasswordRegisterForm(
              onRegisterRequest: (email, password, name) {
                loading = true;
                screen.refresh();
                screen.registerOwner(
                  email,
                  email,
                  password,
                );
              },
            ),
          ],
        )),
      ],
    );
  }
}
