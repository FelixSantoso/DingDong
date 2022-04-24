import 'package:flutter/material.dart';

const authInputDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.black, width: 1.5, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    errorStyle: TextStyle(fontFamily: 'Poppins', fontSize: 16, height: 0.5));

const chatInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(width: 0, style: BorderStyle.none),
  ),
  fillColor: Color.fromARGB(176, 176, 176, 180),
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
);

const formFieldStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
