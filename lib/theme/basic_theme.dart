import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData basicTheme() {
  const Color primaryColor = Color(0xff1fd3ae);
  const Color accentColor = Colors.red;
  //final ThemeData base= ThemeData.light();
  return ThemeData(
      fontFamily: 'Vazir',
      primaryColor: primaryColor,
      accentColor: accentColor,
      textTheme: TextTheme(
        title: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w700,fontStyle: FontStyle.normal),
        subtitle: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w500,fontStyle: FontStyle.normal),
        button: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500,fontStyle: FontStyle.normal),
        display1: TextStyle(color: accentColor, fontSize: 17,fontWeight: FontWeight.w400,fontStyle: FontStyle.normal), //validation
        display2: TextStyle(color: primaryColor, fontSize: 20,fontWeight: FontWeight.w400,fontStyle: FontStyle.normal),//اطلاعات وجود ندارد
        headline: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w500,fontStyle: FontStyle.normal),
        body1: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300,fontStyle: FontStyle.normal),
        body2: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400,fontStyle: FontStyle.normal),
        caption: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400,fontStyle: FontStyle.normal),
      ),
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)))),
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          buttonColor: primaryColor));
}
