import 'dart:io';

import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_init/ui/screens/init_account_screen/init_account_screen.dart';
import 'package:yes_order/module_init/ui/state/init_account/init_account.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class InitAccountCaptainInitProfile extends InitAccountState {
  Uri captainImage;
  Uri driverLicence;
  String name;
  String age;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  InitAccountCaptainInitProfile(InitAccountScreenState screenState)
      : super(screenState);

  InitAccountCaptainInitProfile.withData(InitAccountScreenState screenState,
      this.captainImage, this.driverLicence, this.name, this.age)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    if (this.name != null) {
      _nameController.text = this.name;
    }

    if (this.age != null) {
      _ageController.text = this.age;
    }
    final node = FocusScope.of(context);
    return SafeArea(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0,),
        child: Flex(
          direction: Axis.vertical,
          children: [
            MediaQuery.of(context).viewInsets.bottom != 0
                ? Container()
                : Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        ImagePicker()
                            .getImage(source: ImageSource.gallery)
                            .then((value) {
                          if (value != null) {
                            captainImage = Uri(path: value.path);
                            screen.refresh();
                          }
                        });
                      },
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: Icon(Icons.person,
                                      size: 45, color: Colors.white)),
                              _getCaptainImageFG(),
                            ],
                          )),
                    ),
                  ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                        child: Text('${S.of(context).name}'),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness ==
                                Brightness.dark
                            ? Colors.grey[900]
                            : Color.fromRGBO(236, 239, 241, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: '${S.of(context).name}',
                          prefixIcon: Icon(Icons.person),
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
                        child: Text('${S.of(context).age}'),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness ==
                                Brightness.dark
                            ? Colors.grey[900]
                            : Color.fromRGBO(236, 239, 241, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '${S.of(context).age}',
                          prefixIcon: Icon(Icons.date_range),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),

                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (e) => node.unfocus(),
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
                ],
              ),
            ),
          ],
        ),
      ),
            ),
            Expanded(
      child: Flex(
        direction: Axis.vertical,
        children: [
          Text(
            S.of(context).driverLicence,
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          _getDriverLicenceFG(context),
        ],
      ),
            ),
            Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.maxFinite,
        height: 45,
        child: RaisedButton(
          elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: captainImage == null || captainImage == null
                ? null
                : () {
                    screen.submitProfile(captainImage, driverLicence,
                        _nameController.text, _ageController.text);
                  },
            textColor: Colors.white,
            child: Text(
              S.of(context).uploadAndSubmit,
            )),
      ),
            )
          ],
        ),
    );
  }

  Widget _getDriverLicenceFG(BuildContext context) {
    if (driverLicence != null) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              ImagePicker().getImage(source: ImageSource.gallery).then((value) {
                if (value != null) {
                  captainImage = Uri(path: value.path);
                  screen.refresh();
                }
              });
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: FileImage(File(driverLicence.path)),
                            fit: BoxFit.cover)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            ImagePicker().getImage(source: ImageSource.gallery).then((value) {
              if (value != null) {
                driverLicence = Uri(path: value.path);
                screen.refresh();
              }
            });
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Color.fromRGBO(236, 239, 241, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.camera,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCaptainImageFG() {
    if (captainImage != null) {
      return Container(
          decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(File.fromUri(captainImage)),
          fit: BoxFit.cover,
        ),
      ));
    } else {
      return Container();
    }
  }
}
