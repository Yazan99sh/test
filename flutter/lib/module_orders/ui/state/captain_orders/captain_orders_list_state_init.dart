import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:flutter/material.dart';
import 'captain_orders_list_state.dart';

class OrdersListStateInit extends CaptainOrdersListState {
  OrdersListStateInit(CaptainOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Text(S.of(context).welcomeToOrdersScreen),
    );
  }
}
