import 'package:feature_discovery/feature_discovery.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_init/model/branch/branch_model.dart';
import 'package:yes_order/module_init/ui/screens/init_account_screen/init_account_screen.dart';
import 'package:yes_order/module_init/ui/state/init_account/init_account.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:yes_order/module_init/ui/widget/package_card/behavior.dart';

class InitAccountStateSelectBranch extends InitAccountState {
  List<BranchModel> branchLocation = [];
  final _mapController = MapController();
  bool menu = false;
  InitAccountStateSelectBranch(InitAccountScreenState screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(21.5429423, 39.1690945),
                  zoom: 15.0,
                  onTap: (newPos) {
                    saveMarker(newPos);
                    screen.refresh();
                  },
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: branchLocation == null ? [] : _getMarkers(context),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DescribedFeatureOverlay(
                    featureId:
                        'myLocation', // Unique id that identifies this overlay.
                    tapTarget: Icon(Icons.my_location,
                        color: Theme.of(context)
                            .primaryColor), // The widget that will be displayed as the tap target.
                    title: Text('${S.of(context).myLocation}'),
                    description: Text('${S.of(context).myLocationDescribtion}'),
                    backgroundColor: Theme.of(context).primaryColor,
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          Location location = new Location();

                          bool _serviceEnabled =
                              await location.serviceEnabled();
                          if (!_serviceEnabled) {
                            _serviceEnabled = await location.requestService();
                          }

                          var _permissionGranted =
                              await location.requestPermission();
                          if (_permissionGranted == PermissionStatus.denied) {
                            return;
                          }

                          var myLocation =
                              await Location.instance.getLocation();
                          LatLng myPos =
                              LatLng(myLocation.latitude, myLocation.longitude);
                          _mapController.move(myPos, 15);
                          saveMarker(myPos);
                          screen.refresh();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 55,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DescribedFeatureOverlay(
                    featureId:
                        'selectedMenu', // Unique id that identifies this overlay.
                    tapTarget: Icon(Icons.menu,
                        color: Theme.of(context)
                            .primaryColor), // The widget that will be displayed as the tap target.
                    title: Text('${S.of(context).selectedBranchesMenu}'),
                    description: Text('${S.of(context).selectedBranchesMenuDescribtion}'),
                    backgroundColor: Theme.of(context).primaryColor,
                    targetColor: Colors.white,
                    textColor: Colors.white,

                    child: Container(
                      decoration: BoxDecoration(
                        color: branchLocation.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: branchLocation.isNotEmpty
                            ? () async {
                                menu = true;
                                screen.refresh();
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        menu
            ? TweenAnimationBuilder(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeIn,
                tween: Tween<double>(begin: 0, end: 1),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SafeArea(
                          top: true,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        menu = false;
                                        screen.refresh();
                                      },
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                Localizations.localeOf(context)
                                                            .toString() ==
                                                        'en'
                                                    ? 6.0
                                                    : 0.0,
                                            right:
                                                Localizations.localeOf(context)
                                                            .toString() ==
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
                                    Text(
                                      'Selected Branches',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: CustomBehavior(),
                            child: Scrollbar(
                              child: ListView(
                                children: _getMarkerCards(context),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, bottom: 8, top: 1),
                            child: Container(
                              height: 45,
                              width: double.maxFinite,
                              child: RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                child: Center(
                                    child: Text(S.of(context).saveBranches)),
                                onPressed: branchLocation == null
                                    ? null
                                    : () {
                                        screen.saveBranch(branchLocation);
                                      },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                builder: (_, val, child) {
                  return Transform.scale(
                    scale: val,
                    child: child,
                  );
                },
              )
            : Container()
      ],
    );
  }

  List<Widget> _getMarkerCards(BuildContext context) {
    var branches = <Widget>[];
    for (int i = 0; i < branchLocation.length; i++) {
      branches.add(Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, top: 4, bottom: 4),
        child: Container(
          height: 63,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        '${branchLocation[i].name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  var nameController = TextEditingController();
                                  return AlertDialog(
                                    title: Text(
                                      'Edit Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Container(
                                      height: 180,
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          Align(
                                              alignment: AlignmentDirectional
                                                  .bottomStart,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 4, 20, 4),
                                                child: Text(
                                                    '${S.of(context).newName}'),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 16, 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[900]
                                                    : Color.fromRGBO(
                                                        236, 239, 241, 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  hintText: 'e.g starbox 2',
                                                  prefixIcon: Icon(Icons.store),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.all(16),
                                                ),

                                                textInputAction:
                                                    TextInputAction.done,

                                                // Move focus to next
                                                validator: (result) {
                                                  if (result.isEmpty) {
                                                    return S
                                                        .of(context)
                                                        .pleaseCompleteTheForm;
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                top: 8,
                                                bottom: 8),
                                            child: Container(
                                              height: 45,
                                              width: double.maxFinite,
                                              child: RaisedButton(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Text(
                                                    S.of(context).save,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    if (nameController
                                                        .text.isNotEmpty) {
                                                      Navigator.of(context).pop(
                                                          nameController.text);
                                                    }
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).then((result) {
                              print('Dialog Result $result');
                              if (result != null) {
                                branchLocation[i].name = result;
                                screen.refresh();
                              }
                            });
                            screen.refresh();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            branchLocation.remove(branchLocation[i]);
                            screen.refresh();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            menu = false;
                            _mapController.move(branchLocation[i].location, 15);
                            screen.refresh();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.gps_fixed,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return branches;
  }

  List<Marker> _getMarkers(BuildContext context) {
    var markers = <Marker>[];
    branchLocation.forEach((element) {
      markers.add(Marker(
        point: element.location,
        builder: (ctx) => Container(
          child: Icon(
            Icons.my_location,
            color: Colors.black,
          ),
        ),
      ));
    });
    return markers;
  }

  void saveMarker(LatLng location) {
    branchLocation ??= [];
    branchLocation.add(
      BranchModel(location, '${branchLocation.length + 1}'),
    );
  }
}
