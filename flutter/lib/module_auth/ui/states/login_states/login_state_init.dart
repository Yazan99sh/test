import 'package:yes_order/module_auth/enums/user_type.dart';
import 'package:yes_order/module_auth/ui/screen/login_screen/login_screen.dart';
import 'package:yes_order/module_auth/ui/states/login_states/login_state.dart';
import 'package:yes_order/module_auth/ui/widget/email_password_login/email_password_login.dart';
import 'package:yes_order/module_auth/ui/widget/phone_login/phone_login.dart';
import 'package:yes_order/module_auth/ui/widget/user_type_selector/user_type_selector.dart';
import 'package:flutter/material.dart';

class LoginStateInit extends LoginState {
  UserRole userType = UserRole.ROLE_OWNER;
  final loginTypeController =
      PageController(initialPage: UserRole.ROLE_OWNER.index);

  LoginStateInit(LoginScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 96,
            child: UserTypeSelector(
              currentUserType: screen.currentUserRole ?? userType,
              onUserChange: (newType) {
                userType = newType;
                screen.currentUserRole = newType;
                screen.refresh();
                loginTypeController.animateToPage(
                  userType.index,
                  duration: Duration(milliseconds:350),
                  curve: Curves.linear,
                );
              },
            ),
          ),
          Expanded(
              child: PageView(
            controller: loginTypeController,
            onPageChanged: (pos) {
              userType = UserRole.values[pos];
              screen.currentUserRole = UserRole.values[pos];
              screen.refresh();
            },
            children: [
              PhoneLoginWidget(
                codeSent: false,
                onLoginRequested: (phone) {
                  screen.refresh();
                  screen.loginCaptain(phone);
                },
                onRetry: () {},
                onConfirm: (confirmCode) {
                  screen.refresh();
                  screen.confirmCaptainSMS(confirmCode);
                },
              ),
              EmailPasswordForm(
                onLoginRequest: (email, password) {
                  screen.refresh();
                  screen.loginOwner(
                    email,
                    password,
                  );
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}
