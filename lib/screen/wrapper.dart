// ignore_for_file: prefer_const_constructors

import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/screen/authenticate/auth_page.dart';
import 'package:ding_dong/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId?>(context);
    if (user == null) {
      return AuthPage();
    } else {
      return Home();
    }
  }
}
