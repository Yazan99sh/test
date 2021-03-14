import 'dart:io';

import 'package:yes_order/consts/urls.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_profile/request/profile/profile_request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormWidget extends StatefulWidget {
  final Function(String, String, String) onProfileSaved;
  final Function(String, String, String) onImageUpload;
  final ProfileRequest request;

  ProfileFormWidget({
    @required this.onProfileSaved,
    @required this.onImageUpload,
    this.request,
  });

  @override
  State<StatefulWidget> createState() => _ProfileFormWidgetState(
      request != null ? request.name : null,
      request != null ? request.phone : null);
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String localImage;

  final _formKey = GlobalKey<FormState>();
   String imageAvatar='';

  _ProfileFormWidgetState(String name, String phone) {
    _nameController.text = name;
    _phoneController.text = phone;
    imageAvatar = name;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                ImagePicker()
                    .getImage(source: ImageSource.gallery)
                    .then((value) {
                  widget.onImageUpload(
                    _nameController.text,
                    _phoneController.text,
                    value.path,
                  );
                  setState(() {});
                });
              },
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
                        '${imageAvatar!=null?imageAvatar[0].toUpperCase():'?'}',
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
                                      image: NetworkImage(
                                          widget.request.image.contains('http')
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
            Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text('${S.of(context).name}'),
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
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Text('${S.of(context).phoneNumber}'),
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
                    hintText: '+963 934 567 123',
                    prefixIcon: Icon(Icons.phone),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),

                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => node.unfocus(),
                  // Move focus to next
                  validator: (result) {
                    if (result.isEmpty) {
                      return S.of(context).phoneIsRequired;
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 45,
                width: double.maxFinite,
                child: RaisedButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        widget.onProfileSaved(
                          _nameController.text,
                          _phoneController.text,
                          widget.request.image,
                        );
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text(S.of(context).pleaseCompleteTheForm)));
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
