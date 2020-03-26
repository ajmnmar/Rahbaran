import 'package:flutter/material.dart';
import 'package:rahbaran/helper/style_helper.dart';

class WidgetHelper {
  static Widget messageSection(
      double messageOpacity, double containerTop, String message) {
    return Visibility(
        visible: messageOpacity == 0 ? false : true,
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  opacity: messageOpacity,
                  duration: Duration(milliseconds: 1500),
                  child: Container(
                    margin: EdgeInsets.only(top: containerTop),
                    height: 55,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(message, style: StyleHelper.messageTextStyle),
                  ),
                ))));
  }

  static Widget logoHeaderSection(double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Image.asset(
        "assets/images/logo.png",
        width: width / 3,
      ),
    );
  }
}
