import 'package:flutter/material.dart';

class PrimaryValidation extends StatelessWidget {
  final bool validationVisibility;
  final String validationMessage;

  PrimaryValidation(this.validationVisibility,this.validationMessage);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: validationVisibility,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10),
        child: Text(
          validationMessage,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }
}
