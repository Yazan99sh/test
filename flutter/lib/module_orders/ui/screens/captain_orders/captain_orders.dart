
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:yes_order/module_navigation/menu.dart';
import 'package:yes_order/module_navigation/custom_drawer.dart';
import 'package:yes_order/module_orders/state_manager/captain_orders/captain_orders.dart';
import 'package:yes_order/module_orders/ui/state/captain_orders/captain_orders_list_state.dart';
import 'package:yes_order/module_orders/ui/state/captain_orders/captain_orders_list_state_error.dart';
import 'package:yes_order/module_orders/ui/state/captain_orders/captain_orders_list_state_loading.dart';
import 'package:yes_order/module_profile/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

@provide
class CaptainOrdersScreen extends StatefulWidget {
  final CaptainOrdersListStateManager _stateManager;

  CaptainOrdersScreen(this._stateManager);

  @override
  State<StatefulWidget> createState() => CaptainOrdersScreenState();
}

class CaptainOrdersScreenState extends State<CaptainOrdersScreen> {
  CaptainOrdersListState currentState;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final advancedConroller = AdvancedDrawerController();
  void getMyOrders() {
    widget._stateManager.getMyOrders(this);
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void retry() {
    widget._stateManager.getMyOrders(this);
  }

  void requestAuthorization() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AuthorizationRoutes.LOGIN_SCREEN,
        (r) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    currentState = CaptainOrdersListStateLoading(this);
    widget._stateManager.getMyOrders(this);
    widget._stateManager.stateStream.listen((event) {
      currentState = event;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(currentState);
    return Scaffold(
        key: drawerKey,
        body: CustomAdvancedDrawer(
          controller: advancedConroller,
          backdropColor: Theme.of(context).primaryColor,
          child: Container(color: Theme.of(context).scaffoldBackgroundColor,child: currentState.getUI(context)),
          drawer: MenuScreen(),
        ),
      )
    ;
  }
}
