import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/theme/style_helper.dart';

class WidgetHelper {
  static Widget messageSection1(
      double messageOpacity, double containerTop, String message,
      [bool messageVisibility, onEnd]) {
    return Visibility(
        visible: messageVisibility,
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  opacity: messageOpacity,
                  duration: Duration(milliseconds: 1500),
                  onEnd: onEnd,
                  child: Container(
                    margin: EdgeInsets.only(top: containerTop),
                    height: 55,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(message, style: StyleHelper.messageTextStyle),
                  ),
                ))));
  }

  static Widget logoHeaderSection(double width, [double topPadding]) {
    return Container(
      padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: topPadding == null ? 0 : topPadding,
          bottom: 0),
      child: Image.asset(
        "assets/images/logo.png",
        width: width / 3,
      ),
    );
  }
}

 messageSection(ErrorBloc errorBloc) {
  return BlocBuilder(
      bloc: errorBloc,
      builder: (context, ErrorState state) {
        return Visibility(
            visible: state.messageVisibility,
            child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: double.infinity,
                    child: AnimatedOpacity(
                      opacity: state.messageOpacity,
                      duration: Duration(milliseconds: 1500),
                      onEnd: () {
                        if(state.messageOpacity==0){
                          errorBloc.add(HideErrorEvent());
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        height: 55,
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text(state.message, style: StyleHelper.messageTextStyle),
                      ),
                    ))));
      });
}
