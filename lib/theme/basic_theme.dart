import 'package:flutter/material.dart';

ThemeData basicTheme() {
  const Color primaryColor = Color(0xff1fd3ae);
  const Color accentColor = Colors.red;
  //final ThemeData base= ThemeData.light();
  return ThemeData(
      fontFamily: 'BYekan',
      primaryColor: primaryColor,
      accentColor: accentColor,
      textTheme: TextTheme(
        title: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        button: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        display1: TextStyle(color: accentColor, fontSize: 17), //validation
        subhead: TextStyle(color: primaryColor, fontSize: 20),
        body1: TextStyle(fontSize: 16),
        body2: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),
        caption: TextStyle(fontSize: 17,color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)))),
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          buttonColor: primaryColor));
}
