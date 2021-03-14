import 'package:yes_order/module_orders/ui/screens/captain_orders/captain_orders.dart';

import 'package:flutter/material.dart';

import 'captain_orders_list_state.dart';

class CaptainOrdersListStateUnauthorized extends CaptainOrdersListState {
  CaptainOrdersListStateUnauthorized(CaptainOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    screenState.requestAuthorization();
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
