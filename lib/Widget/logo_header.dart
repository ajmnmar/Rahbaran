import 'dart:math';

import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final double topPadding;

  LogoHeader([double topPadding])
      : this.topPadding = topPadding == null ? 0 : topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: topPadding,// == null ? 0 : topPadding,
          bottom: 0),
      child: Image.asset(
        "assets/images/logo.png",
        width: min(MediaQuery.of(context).size.width / 3,120),
      ),
    );
  }
}
