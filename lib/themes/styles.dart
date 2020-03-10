import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      title: TextStyle(
        // fontFamily: 'Montserrat',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF425398),
      ),
      caption: TextStyle(
        // fontFamily: 'Montserrat',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF425398),
      ),
      subhead: TextStyle(
        // fontFamily: 'Montserrat',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF425398),
      ),
      body1: TextStyle(
        // fontFamily: 'Montserrat',
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
  );

}
TextStyle bigTextStyle = TextStyle(color: Colors.blueGrey[800], fontSize: 20.0, fontWeight: FontWeight.w600);
TextStyle smallTextStyle = TextStyle(color: Colors.blueGrey[800], fontSize: 16.0);
TextStyle mediumTextStyle = TextStyle(color: Colors.blueGrey[800], fontSize: 20.0);
TextStyle smallBoldTextStyle = TextStyle(color: Colors.blueGrey[800], fontSize: 16.0, fontWeight: FontWeight.w600);
TextStyle microTextStyle = TextStyle(color: Colors.blueGrey[800], fontSize: 14.0);
