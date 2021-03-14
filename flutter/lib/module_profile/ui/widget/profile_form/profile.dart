import 'package:yes_order/consts/urls.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_profile/request/profile/profile_request.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final Function() updateProfile;
  final ProfileRequest request;

  ProfileWidget({
    @required this.updateProfile,
    this.request,
  });

  @override
  State<StatefulWidget> createState() => _ProfileWidgetState(
      request != null ? request.name : null,
      request != null ? request.phone : null);
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String name = '';
  String phone = '';
  String localImage;
  _ProfileWidgetState(String pname, String pphone) {
    name = pname;
    phone = pphone;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              '${name.toString()[0].toUpperCase()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50),
                            )),
                          ),
                          widget.request == null
                              ? Container()
                              : widget.request.image == null
                                  ? Container()
                                  : Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(widget
                                                    .request.image
                                                    .contains('http')
                                                ? widget.request.image
                                                : Urls.IMAGES_ROOT +
                                                    widget.request.image),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${name[0].toUpperCase()}${name.substring(1)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Color.fromRGBO(236, 239, 241, 1),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        leading: Icon(Icons.person,color: Theme.of(context).primaryColor),
                        title: Text(
                          '${S.of(context).name}',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          '$name',
                          style: TextStyle(),
                        ),
                      ),
                      ListTile(
                         leading: Icon(Icons.phone,color: Theme.of(context).primaryColor,),
                        title: Text(
                          '${S.of(context).phoneNumber}',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          '$phone',
                          style: TextStyle(),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              width: double.maxFinite,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textColor: Colors.white,
                onPressed: () {
                  widget.updateProfile();
                },
                child: Text('${S.of(context).updateProfile}'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
