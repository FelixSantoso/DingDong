import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/services/database.dart';
import 'package:ding_dong/shared/auth_form_field.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//ignore_for_file: prefer_const_constructors

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String? _currentName;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId>(context);
    return StreamBuilder(
      stream: DatabaseService(user.uid).changeName,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FutureData data = snapshot.data as FutureData;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'UPDATE YOUR NAME',
                  style: formFieldStyle.copyWith(
                      fontSize: 20,
                      letterSpacing: 1,
                      fontFamily: 'Sf',
                      color: Colors.white.withOpacity(0.8)),
                ),
                SizedBox(height: 30),
                TextFormField(
                  initialValue: data.name,
                  style: formFieldStyle.copyWith(color: Colors.white),
                  decoration: authInputDecoration.copyWith(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  validator: (val) {
                    if (val != null) {
                      if (val.isEmpty) {
                        return 'Please enter a name';
                      } else {
                        null;
                      }
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      _currentName = val;
                    });
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(user.uid).upateUserData(
                          _currentName ?? data.name, data.dId, data.email);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Update',
                    style: formFieldStyle,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                ),
                SizedBox(height: 50),
                Expanded(
                  child: Image.asset(
                    'assets/logo2.png',
                    width: 100,
                    height: 100,
                    scale: 5,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading2();
        }
      },
    );
  }
}
