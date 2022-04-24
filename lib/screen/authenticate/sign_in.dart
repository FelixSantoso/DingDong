import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ding_dong/models/random_pass.dart';
import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/services/auth.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//ignore_for_file: prefer_const_constructors

class SignIn extends StatefulWidget {
  final Function? toogleView;
  const SignIn({Key? key, required this.toogleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _dialogKey = GlobalKey<FormState>();

  //text field value
  String email = '';
  String password = '';
  String resetPassword = RandomPassword();
  String resetEmail = '';
  bool loading = false;
  bool loading2 = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetEmailController = TextEditingController();

  late FToast? fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast!.init(context);
    if (email.isNotEmpty) {
      _emailController.text = email;
    }
    if (password.isNotEmpty) {
      _passwordController.text = password;
    }
    if (resetEmail.isNotEmpty) {
      _resetEmailController.text = resetEmail;
    }
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading2 = true;
      });
      dynamic result = await _auth.signInEmail(email, password);
      if (result == 'user-not-found') {
        setState(() {
          loading2 = false;
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'Email not registered',
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        );
      } else if (result == 'wrong-password') {
        setState(() {
          loading2 = false;
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'Wrong password',
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        );
      } else if (result == 'too-many-requests') {
        setState(() {
          loading2 = false;
        });
        fToast!.showToast(
          toastDuration: Duration(milliseconds: 4000),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'Too Many Request.\n'
                "Consider changing your password by pressing the 'Forgot Password?' button.",
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> resetPass(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return loading
                ? LoadingPassReset()
                : Form(
                    key: _dialogKey,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: Text(
                        'Reset Password',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      contentTextStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email',
                          ),
                          TextFormField(
                            controller: _resetEmailController,
                            decoration: authInputDecoration,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter email';
                              } else if (validateEmail(value) == false) {
                                return 'Invalid email address';
                              }
                            },
                            style: formFieldStyle,
                            onChanged: (value) {
                              setState(() {
                                resetEmail = value;
                              });
                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_dialogKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.passReset(
                                        resetEmail, resetPassword);
                                    if (result == 'user-not-found') {
                                      setState(() {
                                        loading = false;
                                      });
                                      fToast!.showToast(
                                        toastDuration:
                                            Duration(milliseconds: 2000),
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              'Email not registered',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (result == 'wrong-password') {
                                      setState(() {
                                        loading = false;
                                        _resetEmailController.clear();
                                      });
                                      Navigator.pop(context);
                                      fToast!.showToast(
                                        gravity: ToastGravity.BOTTOM,
                                        toastDuration:
                                            Duration(milliseconds: 5000),
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          color: Colors.greenAccent[400],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Text(
                                              'The password reset link has been sent to your email',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (result == 'too-many-requests') {
                                      setState(() {
                                        loading = false;
                                        _resetEmailController.clear();
                                      });
                                      Navigator.pop(context);
                                      fToast!.showToast(
                                        gravity: ToastGravity.BOTTOM,
                                        toastDuration:
                                            Duration(milliseconds: 5000),
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          color: Colors.greenAccent[400],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Text(
                                              'The password reset link has been sent to your email',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.greenAccent[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _resetEmailController.clear();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.blue),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading2
        ? Loading2()
        : Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100),
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
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            style: formFieldStyle,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter email';
                              } else if (validateEmail(value) == false) {
                                return 'Invalid email address';
                              }
                            },
                            decoration: authInputDecoration,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            style: formFieldStyle,
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Enter password';
                              } else if (value.length < 6) {
                                return 'Length must be more than 6';
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
                          SizedBox(height: 15),
                          Center(
                            child: Column(
                              children: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    fToast!.removeQueuedCustomToasts();
                                    await resetPass(context);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    fToast!.removeCustomToast();
                                    fToast!.removeQueuedCustomToasts();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    signIn();
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 100),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    fToast?.removeCustomToast();
                                    fToast?.removeQueuedCustomToasts();
                                    widget.toogleView!();
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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
