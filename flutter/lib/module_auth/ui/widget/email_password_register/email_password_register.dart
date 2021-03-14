import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailPasswordRegisterForm extends StatefulWidget {
  final Function(String, String, String) onRegisterRequest;

  EmailPasswordRegisterForm({
    this.onRegisterRequest,
  });

  @override
  State<StatefulWidget> createState() => _EmailPasswordRegisterFormState();
}

class _EmailPasswordRegisterFormState extends State<EmailPasswordRegisterForm> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();

  bool loading = false;
  AutovalidateMode mode;
  @override
  void initState() {
    loading = false;
    super.initState();
    mode = AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    Future.delayed(Duration(seconds: 10), () {
      loading = false;
      if (mounted) setState(() {});
    });
    if (mounted) setState(() {});
    return SingleChildScrollView(
      child: Form(
        key: _registerFormKey,
        autovalidateMode: mode,
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
                      child: Text('${S.of(context).name}'),
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
                      controller: _registerNameController,
                      decoration: InputDecoration(
                        hintText: '${S.of(context).name}',
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),

                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
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
                      borderRadius: BorderRadius.circular(10),
                       color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
                    ),
                    child: TextFormField(
                      controller: _registerEmailController,
                      decoration: InputDecoration(
                        hintText: 'example@mail.com',
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
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
                    ),
                    child: TextFormField(
                      controller: _registerPasswordController,
                      decoration: InputDecoration(
                        hintText: '${S.of(context).password}1234',
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),

                      validator: (result) {
                        if (result.length < 5) {
                          return '${S.of(context).passwordIsTooShort}';
                        }
                        return null;
                      },
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) =>
                          node.unfocus(), // Submit and hide keyboard
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
                            Navigator.popAndPushNamed(
                                context, AuthorizationRoutes.LOGIN_SCREEN);
                          },
                          child: Text(
                            S.of(context).iHaveAnAccount,
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
                            if (_registerFormKey.currentState.validate()) {
                              loading = true;
                              setState(() {});
                              widget.onRegisterRequest(
                                _registerEmailController.text.trim(),
                                _registerPasswordController.text.trim(),
                                _registerNameController.text.trim(),
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
                  )
          ],
        ),
      ),
    );
  }
}
