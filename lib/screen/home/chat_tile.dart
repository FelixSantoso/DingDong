import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//ignore_for_file: prefer_const_constructors

class ChatTile extends StatefulWidget {
  final Chat chat;
  final String myId;

  ChatTile({Key? key, required this.chat, required this.myId})
      : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  String friendName = '';

  bool isSendByMe = true;

  QuerySnapshot? _querySnapshot;

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    if (widget.chat.sendBy == widget.myId) {
      isSendByMe = true;
    } else {
      isSendByMe = false;
    }
    Future getFriendName() async {
      await _databaseService.getUserById(widget.chat.sendBy).then((value) {
        if (!mounted) return;
        setState(() {
          _querySnapshot = value;
          if (_querySnapshot != null) {
            if (_querySnapshot!.docs.isNotEmpty) {
              friendName = _querySnapshot?.docs[0]['Name'];
            }
          } else {
            friendName = '';
          }
        });
      });
    }

    return FutureBuilder(
        future: getFriendName(),
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: isSendByMe
                ? EdgeInsets.only(
                    right: 15,
                  )
                : EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: isSendByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                isSendByMe
                    ? SizedBox(height: 0)
                    : Text(
                        friendName,
                        style: formFieldStyle.copyWith(
                            color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                Row(
                  mainAxisAlignment: isSendByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    isSendByMe
                        ? Text(
                            widget.chat.time,
                            style: formFieldStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontFamily: 'Sf'),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    SizedBox(
                      width: isSendByMe ? 5 : 0,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                        borderRadius: isSendByMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))
                            : BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                        color: Color.fromARGB(239, 239, 239, 255),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        widget.chat.chat,
                        textWidthBasis: TextWidthBasis.longestLine,
                        textAlign: TextAlign.left,
                        style: formFieldStyle.copyWith(fontSize: 15),
                      ),
                    ),
                    SizedBox(width: isSendByMe ? 0 : 5),
                    isSendByMe
                        ? SizedBox(
                            height: 0,
                          )
                        : Text(
                            widget.chat.time,
                            style: formFieldStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Sf',
                                fontSize: 12),
                          )
                  ],
                )
              ],
            ),
          );
        });
  }
}
