import 'dart:ui';

import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/screen/home/settings_form.dart';
import 'package:ding_dong/screen/wrapper.dart';
import 'package:ding_dong/services/auth.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
//ignore_for_file: prefer_const_constructors

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late FToast? fToast;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast!.init(context);
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          backgroundColor: Colors.indigo[900],
          context: context,
          builder: (context) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    final user = Provider.of<UserId?>(context);
    return loading
        ? Loading2()
        : StreamBuilder<Data>(
            stream: DatabaseService(user?.uid).getMyData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Data? userData = snapshot.data;
                return Scaffold(
                    backgroundColor: Color.fromARGB(255, 46, 49, 146),
                    appBar: AppBar(
                      backgroundColor: Color.fromARGB(228, 37, 170, 225),
                      title: Center(
                        child: Text(
                          'Profile',
                          style: formFieldStyle.copyWith(fontSize: 18),
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper()));
                              await _auth.signOut();
                              setState(() {
                                loading = false;
                              });
                            },
                            icon: Icon(
                              Icons.logout_rounded,
                              size: 35,
                              color: Colors.indigo[900],
                            ),
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 5))
                      ],
                    ),
                    body: Padding(
                      padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
                              child: Text(
                                userData!.name[0].toUpperCase(),
                                style: formFieldStyle.copyWith(
                                    fontSize: 80, color: Colors.white),
                              ),
                              radius: 80,
                              backgroundColor: Colors.indigo[900],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Name',
                            textAlign: TextAlign.left,
                            style: formFieldStyle.copyWith(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                userData.name,
                                style: formFieldStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.normal),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showSettingsPanel();
                                },
                                child: Text(
                                  'Change',
                                  style: formFieldStyle.copyWith(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'DD id',
                            style: formFieldStyle.copyWith(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                userData.dId,
                                style: formFieldStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.normal),
                              ),
                              IconButton(
                                onPressed: () {
                                  fToast!.removeQueuedCustomToasts();
                                  fToast!.showToast(
                                    toastDuration: Duration(milliseconds: 5000),
                                    child: Material(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          'Communicate with your friends using the DD id. Your friends can add you by using this id.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.info_rounded,
                                  size: 20,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Email',
                            style: formFieldStyle.copyWith(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          Text(
                            userData.email,
                            style: formFieldStyle.copyWith(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ));
              } else {
                return LoadingPassReset();
              }
            });
  }
}
