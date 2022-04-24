import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/screen/home/chat_room.dart';
import 'package:ding_dong/services/auth.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

//ignore_for_file: prefer_const_constructors
String friendId = '';
String myId = '';
QuerySnapshot? searchSnapshot;
String chatRoomId = '';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  String ddId = '';
  final _databaseService = DatabaseService();
  final _authService = AuthService();
  bool _isPressed = false;
  bool load = false;

  //search result

  Future Search() async {
    await _databaseService.getUserById(ddId).then((value) {
      setState(() {
        searchSnapshot = value;
        if (searchSnapshot != null) {
          if (searchSnapshot!.docs.isNotEmpty) {
            friendId = searchSnapshot?.docs[0]['DD id'];
          }
        } else {
          friendId = '';
        }
      });
    });
  }

  //create chatroom
  chatRoom(String myId) async {
    chatRoomId = getChatRoomId(friendId, myId);
    String tempChatRoomId = getChatRoomId(myId, friendId);
    List<String> user = [friendId, myId];
    DocumentSnapshot temporarySnapshot;
    dynamic result = await _databaseService.getRoom(tempChatRoomId);
    temporarySnapshot = result;
    if (temporarySnapshot.data() != null) {
      chatRoomId = (temporarySnapshot.data() as dynamic)['ChatRoomId'];
      print(chatRoomId);
      print('already exists');
    } else {
      await _databaseService.createChatRoom(chatRoomId, user, chatRoomId);
    }
  }

  Widget loading() {
    return Expanded(
      child: Center(
        child: SpinKitFadingCircle(
          color: Color.fromARGB(228, 37, 170, 225),
          size: 100,
        ),
      ),
    );
  }

  Widget SearchList() {
    if (ddId.isEmpty) {
      setState(() {
        searchSnapshot = null;
        _isPressed = false;
      });
      return Expanded(
        child: Center(
          heightFactor: 4,
          child: Text(
            'Enter id\n than press \nsearch button\n to search',
            textAlign: TextAlign.center,
            style: formFieldStyle.copyWith(
                color: Colors.blue[100],
                wordSpacing: 3,
                letterSpacing: 0.5,
                fontSize: 20),
          ),
        ),
      );
    } else {
      if (_isPressed) {
        if (searchSnapshot != null) {
          if (searchSnapshot!.docs.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchSnapshot?.docs.length,
                  itemBuilder: (context, index) {
                    return SearchResult(
                      name: searchSnapshot?.docs[index]['Name'],
                    );
                  }),
            );
          } else {
            setState(() {
              friendId = '';
            });
            return Center(
              child: Text(
                'Id not found',
                style: formFieldStyle.copyWith(
                    color: Colors.blue[100], wordSpacing: 3, fontSize: 20),
              ),
            );
          }
        } else {
          return loading();
        }
      } else {
        return Expanded(
          child: Center(
            heightFactor: 4,
            child: Text(
              'Enter id\n than press \nsearch button\n to search',
              textAlign: TextAlign.center,
              style: formFieldStyle.copyWith(
                  color: Colors.blue[100],
                  wordSpacing: 3,
                  letterSpacing: 0.5,
                  fontSize: 20),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 49, 146),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(228, 37, 170, 225),
        centerTitle: true,
        title: Text(
          'Add Friend',
          style: formFieldStyle.copyWith(fontSize: 18),
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 176, 176, 176),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  style: formFieldStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                  decoration: InputDecoration.collapsed(
                      hintText: "Id",
                      hintStyle: formFieldStyle.copyWith(
                        color: Colors.white.withOpacity(0.5),
                      )),
                  onChanged: (value) {
                    setState(() {
                      ddId = value;
                    });
                    ;
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isPressed = true;
                    load = true;
                  });
                  Search();
                  FocusManager.instance.primaryFocus?.unfocus();
                  await _SearchResultState().getMyId(user.uid);
                },
                child: Image.asset(
                  'assets/Search.png',
                ),
              ),
            ],
          ),
        ),
        SearchList()
      ]),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, a.length).codeUnitAt(0) >
      b.substring(0, b.length).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}

class SearchResult extends StatefulWidget {
  final String name;

  SearchResult({Key? key, required this.name}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final _databaseService = DatabaseService();

  DocumentSnapshot? _documentSnapshot;
  String sama = '';
  DocumentSnapshot? _samaSnapshot;

  bool isMyself = false;

  Future getMyId(user) async {
    dynamic result = await _databaseService.getMyId(user);
    _documentSnapshot = result;
    myId = (_documentSnapshot?.data() as dynamic)['DD id'];
  }

  @override
  Widget build(BuildContext context) {
    if (friendId == myId) {
      setState(() {
        isMyself = true;
      });
    } else {
      setState(() {
        isMyself = false;
      });
    }
    return Card(
      color: Colors.white.withOpacity(0.3),
      margin: EdgeInsets.symmetric(horizontal: 20),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              child: Text(
                widget.name[0].toUpperCase(),
                style: formFieldStyle.copyWith(fontSize: 40),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              style: formFieldStyle.copyWith(
                fontSize: 25,
                color: Colors.white,
                fontFamily: 'Sf',
              ),
            ),
            SizedBox(height: 20),
            isMyself
                ? Text("Can't add yourself",
                    style: formFieldStyle.copyWith(
                        color: Colors.white.withOpacity(0.8), fontSize: 17))
                : ElevatedButton(
                    onPressed: () async {
                      await _AddFriendState().chatRoom(myId);
                      Navigator.pushReplacementNamed(context, 'chatRoom',
                          arguments: {
                            'friendName': searchSnapshot?.docs[0]['Name'],
                            'chatRoomId': chatRoomId
                          });
                    },
                    child: Text('Add', style: formFieldStyle),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
