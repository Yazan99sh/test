import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_auth/enums/user_type.dart';
import 'package:flutter/material.dart';

//currentUserType
//onUserChange
class UserTypeSelector extends StatefulWidget {
  @override
  _UserTypeSelectorState createState() => _UserTypeSelectorState();
  final Function(UserRole) onUserChange;
  final UserRole currentUserType;

  UserTypeSelector({
    @required this.onUserChange,
    @required this.currentUserType,
  });
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  double width = 125;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: AnimatedAlign(
                    duration: Duration(milliseconds: 500),
                    alignment: widget.currentUserType != UserRole.ROLE_CAPTAIN
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: width,
                      height: 3,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 125,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          width = 250;
                        });
                        widget.onUserChange(UserRole.ROLE_CAPTAIN);
                        Future.delayed(Duration(milliseconds: 350))
                            .whenComplete(() {
                          setState(() {
                            width = 125;
                          });
                        });
                      },
                      child: Text(
                        S.of(context).captain,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 125,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          width = 250;
                        });
                        widget.onUserChange(UserRole.ROLE_OWNER);
                        Future.delayed(Duration(milliseconds: 350))
                            .whenComplete(() {
                          setState(() {
                            width = 125;
                          });
                        });
                      },
                      child: Text(
                        S.of(context).storeOwner,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
