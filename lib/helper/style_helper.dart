import 'package:flutter/material.dart';

class StyleHelper{
  static Color iconColor = Color(0xff1fd3ae);
  static Color mainColor = Color(0xff1fd3ae);
  static OutlineInputBorder textFieldBorder = OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7)));
  static TextStyle buttonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
  static RoundedRectangleBorder buttonRoundedRectangleBorder = RoundedRectangleBorder(borderRadius: BorderRadius.circular(7));
  static TextStyle validationTextStyle = TextStyle(color: Colors.red, fontSize: 17);
  static TextStyle messageTextStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
      color: Colors.black,
      decoration: TextDecoration.none);
  static TextStyle appBarTitleTextStyle=TextStyle(fontSize: 18,fontWeight: FontWeight.w500);
}