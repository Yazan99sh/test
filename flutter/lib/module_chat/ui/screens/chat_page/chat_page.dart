import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:yes_order/generated/l10n.dart';
import 'package:yes_order/module_chat/bloc/chat_page/chat_page.bloc.dart';
import 'package:yes_order/module_chat/model/chat/chat_model.dart';
import 'package:yes_order/module_chat/ui/widget/chat_bubble/chat_bubble.dart';
import 'package:yes_order/module_chat/ui/widget/chat_writer/chat_writer.dart';
import 'package:yes_order/module_upload/service/image_upload/image_upload_service.dart';

@provide
class ChatPage extends StatefulWidget {
  final ChatPageBloc _chatPageBloc;
  final ImageUploadService _uploadService;

  ChatPage(
    this._chatPageBloc,
    this._uploadService,
  );

  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<ChatModel> _chatMessagesList = [];
  int currentState = ChatPageBloc.STATUS_CODE_INIT;

  List<ChatBubbleWidget> chatsMessagesWidgets = [];

  String chatRoomId;

  bool initiated = false;
  bool down = true;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 10), curve: Curves.linear);
      });
    });
    widget._chatPageBloc.chatBlocStream.listen((event) {
      currentState = event.first;
      if (event.first == ChatPageBloc.STATUS_CODE_GOT_DATA) {
        _chatMessagesList = event.last;
        if (chatsMessagesWidgets.length == _chatMessagesList.length) {
        } else {
          buildMessagesList(_chatMessagesList).then((value) {
            if (this.mounted) setState(() {});
          });
        }
      }
      if (scrollController.offset !=
          scrollController.position.maxScrollExtent) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 10), curve: Curves.linear);
      }
    });
    scrollController.addListener(() {
      setState(() {
        if (scrollController.offset !=
            scrollController.position.maxScrollExtent) {
          down = true;
        } else {
          down = false;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentState == ChatPageBloc.STATUS_CODE_INIT) {
      chatRoomId = ModalRoute.of(context).settings.arguments;
      widget._chatPageBloc.getMessages(chatRoomId);
    }
    return Scaffold(
        body: Stack(
      children: [
        Column(
          // direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
                    S.of(context).chatRoom,
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
            Expanded(
                child: Scrollbar(
              child: ListView(
                controller: scrollController,
                children: chatsMessagesWidgets ?? Text(S.of(context).loading),
                reverse: false,
              ),
            )),
            ChatWriterWidget(
              onMessageSend: (msg) {
                widget._chatPageBloc.sendMessage(chatRoomId, msg);
                Future.delayed(Duration(seconds: 1)).whenComplete(() {
                  scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 10),
                      curve: Curves.linear);
                });
              },
              uploadService: widget._uploadService,
            ),
          ],
        ),
        down
            ? Positioned(
                bottom: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 150),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    ));
  }

  Future<void> buildMessagesList(List<ChatModel> chatList) async {
    List<ChatBubbleWidget> newMessagesList = [];
    FirebaseAuth auth = await FirebaseAuth.instance;
    User user = auth.currentUser;
    chatList.forEach((element) {
      newMessagesList.add(ChatBubbleWidget(
        message: element.msg,
        me: element.sender == user.uid ? true : false,
        sentDate: element.sentDate,
      ));
    });
    chatsMessagesWidgets = newMessagesList;
    return;
  }
}
