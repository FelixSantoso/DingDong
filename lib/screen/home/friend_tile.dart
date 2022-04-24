// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/screen/home/add_friend.dart';
import 'package:ding_dong/screen/home/chat_room.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendTile extends StatefulWidget {
  final Friend friend;
  final String myId;
  FriendTile({Key? key, required this.friend, required this.myId})
      : super(key: key);

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  final DatabaseService _databaseService = DatabaseService();
  String friendName = '';
  QuerySnapshot? _querySnapshot;
  dynamic result;
  String friendId = '';
  String roomId = '';

  Future getFriendName() async {
    if (myId != widget.friend.id0) {
      dynamic result =
          await _databaseService.getUserById(widget.friend.id0.toString());
      if (!mounted) return;
      setState(() {
        _querySnapshot = result;
        friendId = widget.friend.id0;
      });
    } else if (myId != widget.friend.id1) {
      dynamic result =
          await _databaseService.getUserById(widget.friend.id1.toString());
      if (!mounted) return;
      setState(() {
        _querySnapshot = result;
        friendId = widget.friend.id1;
      });
    }

    if (_querySnapshot != null) {
      if (_querySnapshot!.docs.isNotEmpty) {
        friendName = _querySnapshot?.docs[0]['Name'];
        return _querySnapshot?.docs[0]['Name'];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future idExists() async {
    String temporaryChatRoomId = getChatRoomId(myId, friendId);
    DocumentSnapshot temporarySnapshot;
    dynamic result = await _databaseService.getRoom(temporaryChatRoomId);
    temporarySnapshot = result;
    temporarySnapshot = result;
    if (temporarySnapshot.data() != null) {
      roomId = (temporarySnapshot.data() as dynamic)['ChatRoomId'];
    } else {
      roomId = getChatRoomId(friendId, myId);
    }
  }

  Widget hasFriend() {
    return Card(
      color: Colors.white.withOpacity(0.3),
      child: ListTile(
        onTap: () async {
          await idExists();
          print(roomId);
          Navigator.pushNamed(context, 'chatRoom',
              arguments: {'friendName': friendName, 'chatRoomId': roomId});
        },
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        leading: CircleAvatar(
          radius: 45,
          child: Text(
            friendName[0].toUpperCase(),
            style: formFieldStyle.copyWith(fontSize: 20),
          ),
        ),
        title: Text(
          friendName,
          style: formFieldStyle.copyWith(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  Widget noFriend() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "You don't have friends yet. Add friends first by pressing the button above which looks like the image below",
            textAlign: TextAlign.center,
            style: formFieldStyle.copyWith(color: Colors.white),
          ),
          Icon(
            Icons.person_add_alt_rounded,
            color: Colors.white,
            size: 50,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFriendName(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? friendName.isNotEmpty
                  ? hasFriend()
                  : noFriend()
              : Center(
                  child: SpinKitPulse(
                    color: Colors.white,
                    size: 50,
                  ),
                );
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //       child: SpinKitPulse(
          //     color: Colors.white,
          //     size: 50,
          //   ));
          // } else if (snapshot.connectionState == ConnectionState.done) {
          //   if (snapshot.data != null) {
          //     return hasFriend();
          //   }
          // }
        });
  }
}
