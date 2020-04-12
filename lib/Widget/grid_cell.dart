import 'package:flutter/material.dart';
import 'package:rahbaran/theme/style_helper.dart';

class PrimaryGridCell extends StatelessWidget {
  final String text;

  PrimaryGridCell(value):text=value==null?'':value.toString();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          alignment: Alignment.centerRight,
          color: StyleHelper.mainColor,
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
          margin: EdgeInsets.all(2),
          child: Text(text)),
    );
  }
}


class SecondaryGridCell extends StatelessWidget {
  final String text;

  SecondaryGridCell(value):text=value==null?'':value.toString();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.centerRight,
            color: Colors.black12,
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            margin: EdgeInsets.all(2),
            child: Text(text)));
  }
}

class TertiaryGridCell extends StatelessWidget {
  final String text;

  TertiaryGridCell(value):text=value==null?'':value.toString();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.centerRight,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            margin: EdgeInsets.all(2),
            child: Text(text)));
  }
}

