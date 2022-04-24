import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/screen/home/add_friend.dart';
import 'package:ding_dong/screen/home/chat_list.dart';
import 'package:ding_dong/screen/home/chat_tile.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//ignore_for_file: prefer_const_constructors

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Map data = {};
  String chat = '';
  final DatabaseService _databaseService = DatabaseService();
  final chatController = TextEditingController();
  DocumentSnapshot? _documentSnapshot;
  String myName = '';
  String myId = '';
  final f = DateFormat('dd-MM-yyyy HH:mm:ss');
  final e = DateFormat('HH:mm');
  bool isPress = false;

  //send button enabled
  Widget enabledButton = IconButton(
    onPressed: () {},
    icon: Icon(
      Icons.send,
      size: 30,
      color: Colors.blue,
    ),
  );

  //send button disabled
  Widget disabledButton = IconButton(
    onPressed: null,
    icon: Icon(
      Icons.send,
      size: 30,
      color: Colors.grey.withOpacity(0.5),
    ),
  );

  //send chat
  sendChat(String chatRoomId) {
    _databaseService.addChat(
        chatRoomId,
        chat.trim(),
        myId,
        DateTime.now().millisecondsSinceEpoch.toString(),
        f.format(DateTime.now()).toString(),
        e.format(DateTime.now()).toString());
  }

  Future getMyId(user) async {
    dynamic result = await _databaseService.getMyId(user);
    _documentSnapshot = result;
    myName = (_documentSnapshot?.data() as dynamic)['Name'];
    myId = (_documentSnapshot?.data() as dynamic)['DD id'];
    return myId;
  }

  @override
  Widget build(BuildContext context) {
    // if (isPress) {
    //   Future.delayed(Duration(seconds: 1));
    //   isPress = false;
    // }
    final user = Provider.of<UserId>(context);
    data = ModalRoute.of(context)?.settings.arguments as Map;
    return StreamProvider<List<Chat>>.value(
      value: DatabaseService(data['chatRoomId']).getChat,
      initialData: const [],
      child: Scaffold(
        extendBody: true,
        backgroundColor: Color.fromARGB(255, 46, 49, 146),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(228, 37, 170, 225),
          title: Text(
            data['friendName'],
            style: formFieldStyle.copyWith(
                fontSize: 20, letterSpacing: 0.5, fontFamily: 'Sf'),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: getMyId(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ChatList(
                      myId: snapshot.data.toString(),
                      isPressed: isPress,
                    );
                  } else {
                    return Loading2();
                  }
                }),
          ),
          Align(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2),
              color: Colors.white,
              child: Row(children: <Widget>[
                Expanded(
                  child: Form(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 5, 20),
                      child: TextFormField(
                        controller: chatController,
                        decoration: chatInputDecoration,
                        style: formFieldStyle,
                        onChanged: (value) {
                          setState(() {
                            chat = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: chatController.text.trim().isEmpty
                      ? disabledButton
                      : IconButton(
                          onPressed: () async {
                            isPress = true;
                            setState(() {
                              chatController.text = '';
                            });
                            sendChat(data['chatRoomId']);
                          },
                          icon: Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                )
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
