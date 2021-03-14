import 'package:flutter_svg/flutter_svg.dart';
import 'package:yes_order/consts/order_status.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/authorization_routes.dart';
import 'package:yes_order/module_orders/model/order/order_model.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:yes_order/module_orders/ui/screens/orders/owner_orders_screen.dart';
import 'package:yes_order/module_orders/ui/widgets/order_widget/order_card.dart';
import 'package:yes_order/module_profile/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

import 'package:timeago/timeago.dart' as timeago;

abstract class OwnerOrdersListState {
  final OwnerOrdersScreenState screenState;

  OwnerOrdersListState(this.screenState);

  Widget getUI(BuildContext context);
}

class OrdersListStateInit extends OwnerOrdersListState {
  OrdersListStateInit(OwnerOrdersScreenState screenState) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Text(S.of(context).welcomeToOrdersScreen),
    );
  }
}

class OrdersListStateLoading extends OwnerOrdersListState {
  OrdersListStateLoading(OwnerOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class OrdersListStateUnauthorized extends OwnerOrdersListState {
  OrdersListStateUnauthorized(OwnerOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          AuthorizationRoutes.LOGIN_SCREEN, (r) => false);
    });
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class OrdersListStateOrdersLoaded extends OwnerOrdersListState {
  final List<OrderModel> orders;

  OrdersListStateOrdersLoaded(this.orders, OwnerOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 75.0),
          child: RefreshIndicator(
            onRefresh: () {
              screenState.getMyOrders();
              return Future.delayed(Duration(seconds: 3));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: () {
                        screenState.getMyOrders();
                        return Future.delayed(Duration(seconds: 3));
                      },
                      child: orders.isNotEmpty
                          ? ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16.0, left: 16, top: 8, bottom: 8),
                                  child: OrderCard(
                                    image: 'deliver.png',
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        OrdersRoutes.ORDER_STATUS_SCREEN,
                                        arguments: orders[index].id,
                                      );
                                    },
                                    title: '${orders[index].from ?? ''}',
                                    subTitle:
                                        '${S.of(context).order} #${orders[index].id}:',
                                    time: timeago.format(
                                        orders[index].creationTime,
                                        locale: Localizations.localeOf(context)
                                            .languageCode),
                                    active: orders[index].status !=
                                        OrderStatus.FINISHED,
                                  ),
                                );
                              })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: SvgPicture.asset(
                                  'assets/images/empty.svg',
                                  width: 225,
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    '${S.of(context).empty}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                              ],
                            )),
                ),
              ],
            ),
          ),
        ),
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
                      //screenState.drawerKey.currentState.openDrawer();
                      screenState.advancedConroller.showDrawer();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Text(
                  S.of(context).home,
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
                      Navigator.of(context)
                          .pushNamed(ProfileRoutes.ACTIVITY_SCREEN);
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                      child: Icon(
                        Icons.flag,
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
      ],
    );
  }

  Future<List<OrderModel>> sortLocations() async {
    Location location = new Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return orders;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      return orders;
    }

    final Distance distance = Distance();

    var myLocation = await Location.instance.getLocation();
    LatLng myPos = LatLng(myLocation.latitude, myLocation.longitude);
    orders.sort((a, b) {
      return distance.as(LengthUnit.Kilometer, a.toOnMap, myPos) -
          distance.as(LengthUnit.Kilometer, b.toOnMap, myPos);
    });
    return orders;
  }
}

class OrdersListStateError extends OwnerOrdersListState {
  final String errorMsg;

  OrdersListStateError(this.errorMsg, OwnerOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Text('${errorMsg}'),
    );
  }
}
