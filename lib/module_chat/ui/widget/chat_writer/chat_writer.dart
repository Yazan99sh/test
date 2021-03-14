import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_order/consts/urls.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_upload/service/image_upload/image_upload_service.dart';

class ChatWriterWidget extends StatefulWidget {
  final Function(String) onMessageSend;
  final ImageUploadService uploadService;

  ChatWriterWidget({
    this.onMessageSend,
    this.uploadService,
  });

  @override
  State<StatefulWidget> createState() => _ChatWriterWidget();
}

class _ChatWriterWidget extends State<ChatWriterWidget> {
  final TextEditingController _msgController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  File imageFile;

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).brightness != Brightness.dark
        ? Colors.grey[900]
        : Color.fromRGBO(236, 239, 241, 1);
    if (imageFile != null) {
      return Container(
        height: 120,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  backgroundBlendMode: BlendMode.darken,
                  color: Colors.black38,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.uploadService
                        .uploadImage(imageFile.path)
                        .then((value) {
                      imageFile = null;
                      sendMessage(value.contains('http')
                          ? value
                          : Urls.IMAGES_ROOT + value);
                      setState(() {});
                    });
                  },
                ),
              ),
            )
          ],
        ),
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4),
          child: IconButton(
            onPressed: () {
              _imagePicker
                  .getImage(source: ImageSource.camera, imageQuality: 70)
                  .then((value) {
                if (value != null) {
                  imageFile = File(value.path);
                  setState(() {});
                }
              });
            },
            icon: Icon(Icons.camera),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4),
          child: IconButton(
            onPressed: () {
              _imagePicker
                  .getImage(source: ImageSource.gallery, imageQuality: 70)
                  .then((value) {
                imageFile = File(value.path);
                setState(() {});
              });
            },
            icon: Icon(Icons.image),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    sendMessage(_msgController.text.trim());
                  },
                  icon: Icon(
                    Icons.send_rounded,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: color, width: 0.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: color, width: 0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: color, width: 0.7),
                ),
                hintText: S.of(context).startWriting,
              ),
              controller: _msgController,
            ),
          ),
        ),
      ],
    );
  }

  void sendMessage(String msg) {
    widget.onMessageSend(msg);
    _msgController.clear();
  }
}
