import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/screen/home/friend_list.dart';
import 'package:ding_dong/screen/home/add_friend.dart';
import 'package:ding_dong/screen/home/profile.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//ignore_for_file: prefer_const_constructors

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseService _databaseService = DatabaseService();
  DocumentSnapshot? _documentSnapshot;

  Future getMyId(user) async {
    dynamic result = await _databaseService.getMyId(user);
    _documentSnapshot = result;
    myId = (_documentSnapshot?.data() as dynamic)['DD id'];
    return (_documentSnapshot?.data() as dynamic)['DD id'];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId>(context);

    return FutureBuilder(
        future: getMyId(user.uid),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? StreamProvider<List<Friend>>.value(
                  value: DatabaseService(myId).friendList,
                  initialData: const [],
                  child: Scaffold(
                      backgroundColor: Color.fromARGB(255, 46, 49, 146),
                      appBar: AppBar(
                        backgroundColor: Color.fromARGB(228, 37, 170, 225),
                        title: Text(
                          'Chats',
                          style: formFieldStyle.copyWith(fontSize: 18),
                        ),
                        actions: <Widget>[
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddFriend()));
                              },
                              icon: Icon(
                                Icons.person_add_alt_rounded,
                                size: 35,
                                color: Colors.indigo[900],
                              )),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'profile');
                            },
                            icon: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.indigo[900],
                            ),
                          ),
                        ],
                      ),
                      body: FriendList(
                        myId: myId,
                      )),
                )
              : Loading2();
        });
  }
}
