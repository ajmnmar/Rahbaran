import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  String message = '';
  double messageOpacity = 0;
  Timer messageTimer;

  void showMessage(String message) {
    if (messageTimer != null) {
      messageTimer.cancel();
    }
    setState(() {
      this.message = message;
      this.messageOpacity = 1;
    });
    messageTimer = new Timer(Duration(seconds: 3), () {
      setState(() {
        this.messageOpacity = 0;
      });
    });
  }

  getApiData(String url) async {
    http.Response response;
    try {
      response = await http.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode != 200) {
        showMessage('خطا در اتصال به سرور!');
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        showMessage('خطا در اتصال به اینترنت!');
      } else {
        showMessage('خطا در اتصال به سرور!');
      }
    }
    return response;
  }
}