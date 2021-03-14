import 'package:yes_order/module_orders/ui/screens/captain_orders/captain_orders.dart';

import 'package:flutter/material.dart';

import 'captain_orders_list_state.dart';

class CaptainOrdersListStateError extends CaptainOrdersListState {
  final String errorMsg;

  CaptainOrdersListStateError(
      this.errorMsg, CaptainOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Container(
      color: Colors.red[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Error ${errorMsg}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                screenState.retry();
              },
              
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
