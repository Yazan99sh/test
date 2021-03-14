import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_init/ui/widget/package_card/behavior.dart';
import 'package:yes_order/module_orders/model/order/order_model.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:yes_order/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:yes_order/module_orders/ui/widgets/order_widget/order_card.dart';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:yes_order/module_profile/profile_routes.dart';
import 'captain_orders_list_state.dart';

class CaptainOrdersListStateOrdersLoaded extends CaptainOrdersListState {
  final List<OrderModel> myOrders;
  final List<OrderModel> orders;

  int currentPage = 0;
  final PageController _ordersPageController = PageController(initialPage: 0);

  CaptainOrdersListStateOrdersLoaded(
      CaptainOrdersScreenState screenState, this.myOrders, this.orders)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 75.0),
          child: Container(
            color: Colors.transparent.withOpacity(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      screenState.getMyOrders();
                      return Future.delayed(Duration(seconds: 3));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: PageView(
                        controller: _ordersPageController,
                        onPageChanged: (pos) {
                          currentPage = pos;
                          screenState.refresh();
                        },
                        children: [
                          FutureBuilder(
                            future: getNearbyOrdersList(context),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<List<Widget>> snapshot,
                            ) {
                              if (snapshot.hasData) {
                                return RefreshIndicator(
                                  onRefresh: () {
                                    screenState.getMyOrders();
                                    return Future.delayed(Duration(seconds: 3));
                                  },
                                  child: Scrollbar(
                                    child: ListView(
                                      children: snapshot.data,
                                    ),
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Container(
                                      width: 125,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[900]
                                              : Color.fromRGBO(
                                                  236, 239, 241, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 35,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text('Loading'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        '${snapshot.error} pull down to refresh'));
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'Empty Stuff',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          FutureBuilder(
                            future: getMyOrdersList(context),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<List<Widget>> snapshot,
                            ) {
                              if (snapshot.hasData) {
                                snapshot.data.add(Container(
                                    height: 65, width: double.maxFinite));
                                return RefreshIndicator(
                                  onRefresh: () {
                                    screenState.getMyOrders();
                                    return Future.delayed(Duration(seconds: 3));
                                  },
                                  child: Scrollbar(
                                    child: ListView(
                                      children: snapshot.data,
                                    ),
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Container(
                                      width: 125,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[900]
                                              : Color.fromRGBO(
                                                  236, 239, 241, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 35,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text('Loading'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        '${snapshot.error} pull down to refresh'));
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'Empty Stuff',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
        Align(
          alignment: Alignment.bottomCenter,
          child: SnakeNavigationBar.color(
            behaviour: SnakeBarBehaviour.pinned,
            snakeShape: SnakeShape.indicator,
            padding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

            ///configuration for SnakeNavigationBar.color
            snakeViewColor: Theme.of(context).primaryColor,
            selectedItemColor: SnakeShape.indicator == SnakeShape.indicator
                ? Theme.of(context).primaryColor
                : null,
            unselectedItemColor: Colors.grey,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,

            ///configuration for SnakeNavigationBar.gradient
            //snakeViewGradient: selectedGradient,
            //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
            //unselectedItemGradient: unselectedGradient,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: currentPage,
            onTap: (index) {
              currentPage = index;
              _ordersPageController.animateToPage(currentPage,
                  duration: Duration(milliseconds: 750), curve: Curves.linear);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car),
                  label: '${S.of(context).currentOrders}'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  label: '${S.of(context).nearbyOrders}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _Footer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)]),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              height: 72,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  IconButton(
                    color: currentPage == 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    icon: Icon(Icons.directions_car),
                    onPressed: () {
                      _ordersPageController.animateToPage(
                        0,
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                      );
                      currentPage = 0;
                      screenState.refresh();
                    },
                  ),
                  Text(
                    S.of(context).currentOrders,
                    style: TextStyle(
                      fontSize: 12,
                      color: currentPage == 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              height: 72,
              child: Column(
                children: [
                  IconButton(
                    color: currentPage == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    icon: Icon(Icons.map_outlined),
                    onPressed: () {
                      _ordersPageController.animateToPage(
                        1,
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                      );
                      currentPage = 1;
                      screenState.refresh();
                    },
                  ),
                  Text(
                    S.of(context).nearbyOrders,
                    style: TextStyle(
                      fontSize: 12,
                      color: currentPage == 1
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> getMyOrdersList(BuildContext context) async {
    var uiList = <Widget>[];

    myOrders.forEach((element) {
      uiList.add(Container(
        margin: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              OrdersRoutes.ORDER_STATUS_SCREEN,
              arguments: element.id,
            );
          },
          child: OrderCard(
            image: 'store.svg',
            title: '${element.storeName}',
            subTitle: S.of(context).order + '#${element.id}',
            time: timeago.format(element.creationTime,
                locale: Localizations.localeOf(context).languageCode),
          ),
        ),
      ));
    });

    return uiList;
  }

  Future<List<Widget>> getNearbyOrdersList(BuildContext context) async {
    var availableOrders = await sortLocations();
    var uiList = <Widget>[];
    availableOrders.forEach((element) {
      uiList.add(Container(
        margin: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              OrdersRoutes.ORDER_STATUS_SCREEN,
              arguments: element.id,
            );
          },
          child: OrderCard(
            image: 'deliver.png',
            title: S.of(context).order + ' #${element.id}',
            subTitle: ' ',
            time: timeago.format(element.creationTime,
                locale: Localizations.localeOf(context).languageCode),
          ),
        ),
      ));
    });
    return uiList;
  }

  Future<List<OrderModel>> sortLocations() async {
    Location location = new Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    var _permissionGranted = await location.requestPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      return orders;
    }

    final Distance distance = Distance();

    var myLocation = await Location.instance.getLocation();
    LatLng myPos = LatLng(myLocation.latitude, myLocation.longitude);
    orders.sort((a, b) {
      try {
        var pos1 = LatLng(a.to.lat, a.to.lon);
        var pos2 = LatLng(b.to.lat, b.to.lon);

        var straightDistance = distance.as(LengthUnit.Kilometer, pos1, myPos) -
            distance.as(LengthUnit.Kilometer, pos2, myPos);
        return straightDistance;
      } catch (e) {
        return 1;
      }
    });
    return orders.toList();
  }
}
