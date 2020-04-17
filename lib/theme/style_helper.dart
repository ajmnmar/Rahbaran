import 'package:flutter/material.dart';

class StyleHelper{
  //general
  static Color iconColor = Color(0xff1fd3ae);
  static Color mainColor = Color(0xff1fd3ae);
  /////////

  //primary flatbutton
  static TextStyle loginFlatButtonTextStyle =
  TextStyle(color: Colors.blue, fontSize: 16);
  static TextStyle loginFlatButtonSeparatorTextStyle =
  TextStyle(color: Colors.black, fontSize: 16);
  ///////////////////////////////

  //promary raisedbutton
  static double raisedButtonHeight=48;
  ////////////////////////////

  //primary container
  static EdgeInsetsGeometry primaryContainerMargin=EdgeInsets.all(10);
  static EdgeInsetsGeometry primaryContainerPadding=EdgeInsets.all(10);
  ////////

  //message
  static TextStyle messageTextStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
      color: Colors.black,
      decoration: TextDecoration.none);
  /////////


}