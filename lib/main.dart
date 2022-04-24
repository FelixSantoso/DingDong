import 'package:ding_dong/screen/home/chat_room.dart';
import 'package:ding_dong/screen/home/home.dart';
import 'package:ding_dong/screen/home/profile.dart';
import 'package:ding_dong/screen/wrapper.dart';
import 'package:ding_dong/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:ding_dong/models/user.dart';
//ignore_for_file: prefer_const_constructors

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserId?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        routes: {
          'profile': (context) => Profile(),
          'home': ((context) => Home()),
          'chatRoom': ((context) => ChatRoom()),
          'wrapper': ((context) => Wrapper())
        },
        home: Wrapper(),
      ),
    );
  }
}
