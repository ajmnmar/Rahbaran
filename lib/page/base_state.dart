import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:rahbaran/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final int httpRequestTimeout = 30;

  ErrorBloc errorBloc = new ErrorBloc();


  getApiData(String url, {Map<String, String> headers}) async {
    http.Response response;
    try {
      if (headers==null) {
        response = await http.get(url);
      }else{
        response = await http
            .get(url, headers: headers);
        //.timeout(Duration(seconds: httpRequestTimeout));
      }
      if (response.statusCode == 401) {
        SharedPreferences.getInstance().then((SharedPreferences val) {
          val.clear();
          Navigator.of(context).pushNamedAndRemoveUntil(Login.routeName,
                  (Route<dynamic> rout) => false);
        });
      } else if (response.statusCode != 200) {
        errorBloc.add(ShowErrorEvent('خطا در اتصال به سرور!'));
        return;
      }
    } on Exception catch (e) {
      if (e is SocketException || e is TimeoutException) {
        errorBloc.add(ShowErrorEvent('خطا در اتصال به اینترنت!'));
      } else {
        errorBloc.add(ShowErrorEvent('خطا در اتصال به سرور!'));
      }
      return;
    }
    return response;
  }

  postApiData(String url, {Map<String, String> headers, String body}) async {
    http.Response response;
    try {
      if ((body==null || body.isEmpty)&&(headers==null)) {
        response =
        await http.post(url);//.timeout(Duration(seconds: httpRequestTimeout));
      }else if(body==null || body.isEmpty){
        response = await http
            .post(url, headers: headers);
            //.timeout(Duration(seconds: httpRequestTimeout));
      }else if (headers==null){
        response = await http
            .post(url, body: body);
            //.timeout(Duration(seconds: httpRequestTimeout));
      }
      else {
        response = await http
            .post(url, headers: headers, body: body);
            //.timeout(Duration(seconds: httpRequestTimeout));
      }
      if (response.statusCode == 401) {
        SharedPreferences.getInstance().then((SharedPreferences val) {
          val.clear();
          Navigator.of(context).pushNamedAndRemoveUntil(Login.routeName,
                  (Route<dynamic> rout) => false);
        });
      }
      else if (response.statusCode != 200) {
        errorBloc.add(ShowErrorEvent('خطا در اتصال به سرور!'));
        return;
      }
    } on Exception catch (e) {
      if (e is SocketException || e is TimeoutException) {
        errorBloc.add(ShowErrorEvent('خطا در اتصال به اینترنت!'));
      } else {
        errorBloc.add(ShowErrorEvent('خطا در اتصال به سرور!'));
      }
      return;
    }
    return response;
  }


}
