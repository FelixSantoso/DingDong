import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/screen/home/add_friend.dart';
import 'package:ding_dong/screen/home/friend_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//ignore_for_fiel: const_prefer_constructors

class FriendList extends StatefulWidget {
  final String myId;
  const FriendList({Key? key, required this.myId}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    final friend = Provider.of<List<Friend>>(context);
    return ListView.builder(
      itemCount: friend.length,
      itemBuilder: (context, index) {
        return FriendTile(
          friend: friend[index],
          myId: myId,
        );
      },
    );
  }
}
