import 'package:flutter_svg/flutter_svg.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_init/model/package/packages.model.dart';
import 'package:yes_order/module_init/ui/screens/init_account_screen/init_account_screen.dart';
import 'package:yes_order/module_init/ui/state/init_account/init_account.state.dart';
import 'package:yes_order/module_init/ui/widget/package_card/package_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InitAccountStatePackagesLoaded extends InitAccountState {
  List<PackageModel> packages;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCity;
  String _selectedSize;
  int _selectedPackageId;
  ScrollController _scrollController = ScrollController();
  InitAccountStatePackagesLoaded(
    this.packages,
    InitAccountScreenState screen,
  ) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    final node = FocusScope.of(context);
    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaQuery.of(context).viewInsets.bottom == 0
                ? SvgPicture.asset(
                    'assets/images/store.svg',
                    width: 150,
                  )
                : Container(),
            Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  child: Text('${S.of(context).storeName}'),
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
                    hintText: 'e.g starbox',
                    prefixIcon: Icon(Icons.store),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),

                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
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
            Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  child: Text('${S.of(context).storePhone}'),
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
keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  // Move focus to next
                  validator: (result) {
                    if (result.isEmpty) {
                      return S.of(context).pleaseCompleteTheForm;
                    }
                    return null;
                  },
                ),
              ),
            ),

            //size
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 23, 16, 8),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
                    child: DropdownButtonFormField(
                        value: _selectedSize,
                        dropdownColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[900]
                                : Color.fromRGBO(236, 239, 241, 1),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: S.of(context).chooseYourSize,
                        ),
                        items: _getSizes(context),
                        onChanged: (value) {
                          _selectedSize = value;
                          screen.refresh();
                        }),
                  ),
                ),
              ),
            ),

            //city
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 23, 16, 23),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
                    child: DropdownButtonFormField(
                        value: _selectedCity,
                        dropdownColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[900]
                                : Color.fromRGBO(236, 239, 241, 1),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: S.of(context).chooseYourCity,
                        ),
                        items: _getCities(),
                        onChanged: (value) {
                          _selectedCity = value;
                          screen.refresh();
                        }),
                  ),
                ),
              ),
            ),

            //package
            _selectedCity != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 750),
                      curve: Curves.easeIn,
                      tween: Tween<double>(begin: 0, end: 1),
                      child: Container(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _getPackages(),
                        ),
                      ),
                      builder: (context, val, child) {
                        return Transform.scale(
                          scale: val,
                          child: child,
                        );
                      },
                    ),
                  )
                : Container(),

            _selectedPackageId != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 750),
                      curve: Curves.easeIn,
                      tween: Tween<double>(begin: 0, end: 1),
                      child: Container(
                        height: 45,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            screen.subscribeToPackage(
                              _selectedPackageId,
                              _nameController.text,
                              _phoneController.text,
                              _selectedCity,
                            );
                          },
                          child: Text(
                            S.of(context).next,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      builder: (context, val, child) {
                        return Transform.scale(
                          scale: val,
                          child: child,
                        );
                      },
                    ),
                  )
                : Container(
                    height: 45,
                    width: double.maxFinite,
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getPackages() {
    if (packages == null) {
      return [];
    }
    if (packages.isEmpty) {
      return [];
    }
    if (_selectedCity == null) {
      return [];
    }

    return packages.map((element) {
      return GestureDetector(
        onTap: () {
          if (_scrollController.offset <=
              _scrollController.position.maxScrollExtent) {
            _scrollController.animateTo(10000,
                duration: Duration(milliseconds: 750), curve: Curves.easeIn);
          }
          _selectedPackageId = element.id;
          screen.refresh();
        },
        child: PackageCard(
          package: element,
          active: element.id == _selectedPackageId,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem> _getCities() {
    var cityNames = <String>{};
    packages.forEach((element) {
      cityNames.add('${element.city}');
    });

    var cityDropDown = <DropdownMenuItem>[];
    cityNames.forEach((element) {
      cityDropDown.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });

    return cityDropDown;
  }

  List<DropdownMenuItem> _getSizes(BuildContext context) {
    var sizeDropdowns = <DropdownMenuItem>[];
    sizeDropdowns.add(DropdownMenuItem(
      child: Text(S.of(context).smallLessThan20Employee),
      value: 'sm',
    ));
    sizeDropdowns.add(DropdownMenuItem(
      child: Text(S.of(context).mediumMoreThan20EmployeesLessThan100),
      value: 'md',
    ));
    sizeDropdowns.add(DropdownMenuItem(
      child: Text(S.of(context).largeMoreThan100Employees),
      value: 'lg',
    ));

    return sizeDropdowns;
  }
}
