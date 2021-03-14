import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailPasswordForm extends StatefulWidget {
  final Function(String, String) onLoginRequest;
  final String email;
  final String password;

  EmailPasswordForm({
    this.onLoginRequest,
    this.email,
    this.password,
  });

  @override
  State<StatefulWidget> createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  bool loading = false;
  AutovalidateMode mode;
  @override
  void initState() {
    super.initState();
    mode = AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    _loginEmailController.text = widget.email;
    _loginPasswordController.text = widget.password;

    return Form(
      key: _loginFormKey,
      autovalidateMode: mode,
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/images/register_form.svg',
                    width: 125,
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                      child: Text('${S.of(context).email}'),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _loginEmailController,
                      decoration: InputDecoration(
                        hintText: '${S.of(context).email}',
                        prefixIcon: Icon(Icons.email),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),

                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      // Move focus to next
                      validator: (result) {
                        if (result.isEmpty) {
                          return S.of(context).emailAddressIsRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                      child: Text('${S.of(context).password}'),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _loginPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '${S.of(context).password}1234',
                        prefixIcon: Icon(Icons.lock),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),

                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (e) {
                        node.unfocus();
                      },
                      // Move focus to next
                      validator: (result) {
                        if (result.isEmpty) {
                          return S.of(context).nameIsRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
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
                : Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, left: 16, top: 16),
                        child: RaisedButton(
                          elevation: 0,
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AuthorizationRoutes.REGISTER_SCREEN);
                          },
                          child: Text(
                            S.of(context).register,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RaisedButton(
                          elevation: 0,
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              mode = AutovalidateMode.always;
                            });
                            if (_loginFormKey.currentState.validate()) {
                              loading = true;
                              setState(() {});
                              widget.onLoginRequest(
                                _loginEmailController.text,
                                _loginPasswordController.text,
                              );
                            }
                          },
                          child: Text(
                            S.of(context).next,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
