import 'package:flutter/material.dart';

import 'base_state.dart';

abstract class ValidationBaseState<T extends StatefulWidget> extends BaseState<T> {
  bool validationVisibility = false;
  String validationMessage = '';

  void showValidation(String message) {
    setState(() {
      validationMessage = message;
      validationVisibility = true;
    });
  }

  void hideValidation() {
    setState(() {
      validationMessage = '';
      validationVisibility = false;
    });
  }
}