import 'package:flutter/material.dart';
import 'package:rahbaran/helper/style_helper.dart';

class WidgetHelper{
  static Widget messageSection(double messageOpacity,double containerTop,String message){
    return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
            width: double.infinity,
            child: AnimatedOpacity(
              opacity: messageOpacity,
              duration: Duration(milliseconds: 1500),
              child: Container(
                margin: EdgeInsets.only(
                    top: containerTop),
                height: 35,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                    message,
                    style: StyleHelper.messageTextStyle
                ),
              ),
            )
        )
    );
  }
}