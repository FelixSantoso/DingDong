import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/services/auth.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

//ignore_for_file: prefer_const_constructors

class Register extends StatefulWidget {
  final Function? toogleView;
  const Register({Key? key, required this.toogleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field value
  String name = '';
  String dId = '';
  String email = '';
  String password = '';
  bool loading = false;

  late FToast? fToast;
  QuerySnapshot? searchSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast!.init(context);
  }

  Future<void> regisEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
        name = email[0].toUpperCase() +
            email.substring(
                1, email.indexOf(RegExp(r"[!@#$%^&*(),.?:{}'_;/\`~|<>]")));
      });
      dynamic value = await _databaseService.getUserById(dId);
      searchSnapshot = value;
      if (searchSnapshot != null) {
        if (searchSnapshot!.docs.isNotEmpty) {
          setState(() {
            loading = false;
          });
          fToast!.showToast(
            toastDuration: Duration(milliseconds: 2000),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              color: Colors.red,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Id has been used',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          );
        } else {
          dynamic result = await _auth.signUpEmail(email, password, dId, name);
          if (result == null) {
            setState(() {
              loading = false;
            });
            fToast!.showToast(
              toastDuration: Duration(milliseconds: 2000),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                color: Colors.red,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Email already registered',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            );
          } else {
            print('fail');
          }
        }
      } else {
        dynamic result = await _auth.signUpEmail(email, password, dId, name);
        if (result == null) {
          setState(() {
            loading = false;
          });
          fToast!.showToast(
            toastDuration: Duration(milliseconds: 2000),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              color: Colors.red,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Email already registered',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          );
        } else {
          print('fail');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading2()
        : Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 80),
                    Image(
                      image: AssetImage('assets/logo2.png'),
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            "DD'Id",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                dId = value;
                              });
                            },
                            decoration: authInputDecoration,
                            style: formFieldStyle,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter DD Id';
                              } else if (value.length <= 2) {
                                return 'Length must be more than 2';
                              } else if (value.contains(' ')) {
                                return 'Id cannot contain spaces';
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            style: formFieldStyle,
                            decoration: authInputDecoration,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter email';
                              } else {
                                if (validateEmail(value) == false) {
                                  return 'Invalid email address';
                                }
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          SizedBox(height: 11),
                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            style: formFieldStyle,
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Enter password';
                              } else if (value.length < 6) {
                                return 'Length must be more than 6';
                              } else if (!value.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                return 'Contain at leat 1 special character';
                              } else if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Contain at least 1 uppercase';
                              }
                            }),
                            obscureText: true,
                            decoration: authInputDecoration,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                regisEmail();
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(228, 37, 170, 225),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 100)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                              ),
                              TextButton(
                                  onPressed: () {
                                    widget.toogleView!();
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
