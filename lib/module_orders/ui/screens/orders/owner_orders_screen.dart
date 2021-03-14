import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_deep_links/service/deep_links_service.dart';
import 'package:yes_order/module_navigation/menu.dart';
import 'package:yes_order/module_navigation/custom_drawer.dart';
import 'package:yes_order/module_navigation/ui/widget/drawer_widget/drawer_widget.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:yes_order/module_orders/state_manager/owner_orders/owner_orders.state_manager.dart';
import 'package:yes_order/module_orders/ui/state/owner_orders/orders.state.dart';
import 'package:yes_order/module_profile/profile_routes.dart';
import 'package:yes_order/module_settings/setting_routes.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

@provide
class OwnerOrdersScreen extends StatefulWidget {
  final OwnerOrdersStateManager _stateManager;

  OwnerOrdersScreen(
    this._stateManager,
  );

  @override
  OwnerOrdersScreenState createState() => OwnerOrdersScreenState();
}

class OwnerOrdersScreenState extends State<OwnerOrdersScreen> {
  OwnerOrdersListState _currentState;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final advancedConroller = AdvancedDrawerController();
  void getMyOrders() {
    widget._stateManager.getMyOrders(this);
  }

  void addOrderViaDeepLink(LatLng location) {
    _currentState = OrdersListStateInit(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context)
          .pushNamed(OrdersRoutes.NEW_ORDER_SCREEN, arguments: location);
    });
  }

  void discovery() {
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'AddNewOrder',
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _currentState = OrdersListStateInit(this);

    widget._stateManager.stateStream.listen((event) {
      _currentState = event;
      if (mounted) {
        setState(() {});
      }
    });

    DeepLinksService.checkForGeoLink().then((value) {
      if (value != null) {
        Navigator.of(context).pushNamed(
          OrdersRoutes.NEW_ORDER_SCREEN,
          arguments: value,
        );
      }
    });

    widget._stateManager.getMyOrders(this);
  }

  @override
  Widget build(BuildContext context) {
    print(_currentState);

    return GestureDetector(
      onTap: () {
        final node = FocusScope.of(context);
        if (node.canRequestFocus) {
          node.unfocus();
        }
      },
      child: Scaffold(
        key: drawerKey,
        body: CustomAdvancedDrawer(
            controller: advancedConroller,
            backdropColor: Theme.of(context).primaryColor,
            child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _currentState.getUI(context)),
            drawer: MenuScreen()),
        floatingActionButton: _currentState is OrdersListStateOrdersLoaded
            ? DescribedFeatureOverlay(
                featureId:
                    'AddNewOrder', // Unique id that identifies this overlay.
                tapTarget: Icon(Icons.add,
                    color: Theme.of(context)
                        .primaryColor), // The widget that will be displayed as the tap target.
                title: Text('${S.of(context).addNewOrder}'),
                description: Text('${S.of(context).addNewOrderDescribtion}'),
                backgroundColor: Theme.of(context).primaryColor,
                targetColor: Colors.white,
                textColor: Colors.white,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: 'create order',
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(OrdersRoutes.NEW_ORDER_SCREEN);
                  },
                ),
              )
            : null,
      ),
    
    );
  }
}
