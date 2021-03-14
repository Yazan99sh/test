import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:yes_order/consts/branch.dart';
import 'package:yes_order/module_orders/orders_routes.dart';
import 'package:yes_order/module_orders/response/orders/orders_response.dart';
import 'package:yes_order/module_orders/ui/screens/new_order/new_order_screen.dart';
import 'package:yes_order/module_profile/response/create_branch_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:lottie/lottie.dart';

abstract class NewOrderState {
  NewOrderScreenState screenState;

  NewOrderState(this.screenState);

  Widget getUI(BuildContext context);
}

class NewOrderStateInit extends NewOrderState {
  NewOrderStateInit(NewOrderScreenState screenState) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class NewOrderStateSuccessState extends NewOrderState {
  final _contactFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  NewOrderStateSuccessState(NewOrderScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    final node = FocusScope.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Lottie.asset('assets/animations/on-way.json')),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _contactFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                      child: Text('${S.of(context).deliverTo}'),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g ${S.of(context).mohammad}',
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),

                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      // Move focus to next
                      validator: (result) {
                        if (result.isEmpty) {
                          return S.of(context).pleaseProvideUsWithTheClientName;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                      child: Text('${S.of(context).recipientPhoneNumber}'),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'e.g +963 912 345 678',
                        prefixIcon: Icon(Icons.phone),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),

                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (e) => node.unfocus(),
                      // Move focus to next
                      validator: (result) {
                        if (result.isEmpty) {
                          return S
                              .of(context)
                              .pleaseProvideUsTheClientPhoneNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 72,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    height: 45,
                    child: RaisedButton(
                      elevation: 0,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        screenState.addNewOrder(
                            _nameController.text, _phoneController.text);
                      },
                      child: Text(
                        S.of(context).skip,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 8,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    height: 45,
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_contactFormKey.currentState.validate()) {
                          screenState.addNewOrder(
                              _nameController.text, _phoneController.text);
                        } else {
                          screenState.showSnackBar(
                              S.of(context).pleaseCompleteTheForm);
                        }
                      },
                      child: Text(
                        S.of(context).save,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class NewOrderStateBranchesLoaded extends NewOrderState {
  List<Branch> branches;

  final List<String> _paymentMethods = ['online', 'cash'];
  String _selectedPaymentMethod = 'online';
  DateTime orderDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  Branch activeBranch;

  NewOrderStateBranchesLoaded(
      this.branches, LatLng location, NewOrderScreenState screenState)
      : super(screenState) {
    if (location != null) {
      _toController.text = S.current.fromWhatsapp;
    }
  }

  @override
  Widget getUI(context) {
    orderDate ??= DateTime.now();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
              top: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.of(context).pop();
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
                    S.of(context).newOrder,
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
                      onTap: () {},
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                SvgPicture.asset('assets/images/new_order.svg',width: 100,),
                  Padding
                  (
                    padding: const EdgeInsets.all(16),
                    child: getBranchSelector(context),
                  ),
                  //to
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, right: 16, left: 16),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        //rgb(28,27,45)
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Color.fromRGBO(236, 239, 241, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _toController,
                        style: TextStyle(),
                        decoration: InputDecoration(
                          hintText: '${S.of(context).to}',
                          hintStyle: TextStyle(),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right:4.0,left: 4),
                            child: IconButton(
                              splashRadius: 12,
                              onPressed: () {
                                getClipBoardData().then((value) {
                                  _toController.text = value;
                                  screenState.refresh();
                                });
                              },
                              icon: Icon(
                                Icons.paste,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(top: 12, left: 16, right: 16),
                        ),

                        textInputAction: TextInputAction.done,

                        // Move focus to next
                        validator: (result) {
                          if (result.isEmpty) {
                            return S.of(context).nameIsRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  //payment method
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, right: 16.0, left: 16.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color:  Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top:8,bottom: 8,left: 16,right: 16),
                          enabledBorder:InputBorder.none,
                          hintText: S.of(context).paymentMethod,
                          hintStyle: TextStyle(),
                          fillColor:  Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
                          
                        ),
                        dropdownColor:  Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
                        value: _selectedPaymentMethod ?? 'cash',
                        items: _paymentMethods
                            .map((String method) => DropdownMenuItem(
                                  value: method.toString(),
                                  child: Text(
                                    method == 'cash'
                                        ? S.of(context).cash
                                        : S.of(context).online,
                                    style: TextStyle(),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _selectedPaymentMethod =
                              _paymentMethods.firstWhere(
                                  (element) => element.toString() == value);
                          screenState.refresh();
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, left: 16, right: 16),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(236, 239, 241, 1),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            DatePicker.showTimePicker(
                              context,
                            ).then((value) {
                              orderDate = value;
                              screenState.refresh();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                  '${orderDate.toIso8601String().substring(11, 16)}',
                                  style: TextStyle(
                                   
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),

            //info
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right:16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                ),
                child: TextFormField(
                  controller: _infoController,
                  autofocus: false,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: '${S.of(context).to}',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(top: 12, left: 16, right: 16),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 45,
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).cancel,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 45,
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (activeBranch == null) {
                          screenState
                              .showSnackBar(S.of(context).pleaseSelectABranch);
                          return;
                        }
                        screenState.initNewOrder(
                          activeBranch,
                          GeoJson(lat: 0, lon: 0),
                          _infoController.text.trim(),
                          _selectedPaymentMethod ??
                              _selectedPaymentMethod.trim(),
                          orderDate.toIso8601String(),
                        );
                      },
                      child: Text(
                        S.of(context).apply,
                        style: TextStyle(
                          color: Colors.white,
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
    );
  }

  Future<String> getClipBoardData() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    return data.text;
  }

  Widget getBranchSelector(BuildContext context) {
    if (branches == null) {
      return Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Color.fromRGBO(236, 239, 241, 1),
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.only(right:16.0,left:16),
            child: Text(
              S.of(context).errorLoadingBranches,
              style: TextStyle(),
            ),
          ),
        ),
      );
    } else if (branches.length == 1) {
      activeBranch = branches[0];
      return Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
             padding: const EdgeInsets.only(right:16.0,left:16),
            child: Text(
              S.of(context).defaultBranch,
              style: TextStyle(),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: DropdownButtonFormField(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: InputDecoration(
                  enabledBorder:InputBorder.none,
                  fillColor:  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                  focusColor:  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                  hintText: S.of(context).branch,
                  hintStyle: TextStyle(),
                ),
                items: branches
                    .map((e) => DropdownMenuItem<Branch>(
                          value: e,
                          child: Text(
                            '${S.of(context).branch} ${e.brancheName}',
                            style: TextStyle(
                            
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  activeBranch = val;
                }),
          ),
        ),
      );
    }
  }
}

class NewOrderStateErrorState extends NewOrderState {
  String errMsg;

  NewOrderStateErrorState(this.errMsg, NewOrderScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Text('${errMsg}'),
    );
  }
}
