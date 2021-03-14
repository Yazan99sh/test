import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_about/state_manager/about_screen_state_manager.dart';
import 'package:yes_order/module_about/ui/states/about/about_state.dart';
import 'package:yes_order/module_about/ui/states/about/about_state_page_init.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  final AboutScreenStateManager _stateManager;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AboutScreen(this._stateManager);

  @override
  State<StatefulWidget> createState() => _AboutScreenState();

  void moveToRegister() {
    Navigator.of(_scaffoldKey.currentContext)
        .pushNamed(AuthorizationRoutes.LOGIN_SCREEN);
  }

  void showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
}

class _AboutScreenState extends State<AboutScreen> {
  AboutState _currentState;

  @override
  void initState() {
    widget._stateManager.stateStream.listen((event) {
      _currentState = event;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final node = FocusScope.of(context);
        if (node.canRequestFocus) {
          node.unfocus();
        }
      },
      child: Scaffold(
          key: widget._scaffoldKey,
          body: _currentState != null
              ? _currentState.getUI(context)
              : AboutStatePageInit(widget._stateManager).getUI(context)),
    );
  }
}
//move to register
