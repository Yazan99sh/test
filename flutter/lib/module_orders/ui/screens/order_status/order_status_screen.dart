import 'package:yes_order/consts/order_status.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_orders/model/order/order_model.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:yes_order/module_orders/state_manager/order_status/order_status.state_manager.dart';
import 'package:yes_order/module_orders/ui/state/order_status/order_details_state_captain_order_loaded.dart';
import 'package:yes_order/module_orders/ui/state/order_status/order_details_state_owner_order_loaded.dart';
import 'package:yes_order/module_orders/ui/state/order_status/order_status.state.dart';
import 'package:yes_order/module_report/ui/widget/report_dialog/report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';

@provide
class OrderStatusScreen extends StatefulWidget {
  final OrderStatusStateManager _stateManager;

  OrderStatusScreen(
    this._stateManager,
  );

  @override
  OrderStatusScreenState createState() => OrderStatusScreenState();
}

class OrderStatusScreenState extends State<OrderStatusScreen> {
  int orderId;
  OrderDetailsState currentState;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    widget._stateManager.stateStream.listen((event) {
      currentState = event;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void requestOrderProgress(OrderModel currentOrder, [String distance]) {
    OrderStatus newStatus;
    switch (currentOrder.status) {
      case OrderStatus.INIT:
        newStatus = OrderStatus.GOT_CAPTAIN;
        break;
      case OrderStatus.GOT_CAPTAIN:
        newStatus = OrderStatus.IN_STORE;
        break;
      case OrderStatus.IN_STORE:
        newStatus = OrderStatus.DELIVERING;
        break;
      case OrderStatus.DELIVERING:
        newStatus = currentOrder.paymentMethod == 'CASH'
            ? OrderStatus.GOT_CAPTAIN
            : OrderStatus.FINISHED;
        break;
      case OrderStatus.GOT_CASH:
        newStatus = OrderStatus.FINISHED;
        break;
      case OrderStatus.FINISHED:
        break;
    }

    currentOrder.distance = distance;
    currentOrder.status = newStatus;
    widget._stateManager.updateOrder(currentOrder, this);
  }

  @override
  Widget build(BuildContext context) {
    print(currentState);
    if (currentState == null) {
      orderId = ModalRoute.of(context).settings.arguments;
      widget._stateManager.getOrderDetails(orderId, this);
      currentState = OrderDetailsStateInit(this);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              top: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        if (currentState is OrderDetailsStateOwnerOrderLoaded) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              OrdersRoutes.OWNER_ORDERS_SCREEN,
                              (route) => false);
                        } else if (currentState
                            is OrderDetailsStateCaptainOrderLoaded) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              OrdersRoutes.CAPTAIN_ORDERS_SCREEN,
                              (route) => false);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: Localizations.localeOf(context).toString() ==
                                    'en'
                                ? 6.0
                                : 0.0,
                            right: Localizations.localeOf(context).toString() ==
                                    'en'
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
                  Text(
                    S.of(context).orderDetails,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        showDialog(
                          context: context,
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: ReportDialogWidget(),
                          ),
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          if (value is String) {
                            if (value.isNotEmpty) {
                              widget._stateManager.report(orderId, value);
                              showSnackBar(S.of(context).reportSent);
                            }
                          }
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor),
                        child: Icon(
                          Icons.report,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: currentState.getUI(context))
        ],
      ),
    );
  }
}
