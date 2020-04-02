import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'base_state.dart';
import 'freighter.dart';
import 'login.dart';
import 'news.dart';

abstract class BaseAuthorizedState<T extends StatefulWidget>
    extends BaseState<T> {
  String token;
  UserModel currentUser;
  int bottomNavigationSelectedIndex = 0;
  bool isActiveBottomNavigation=true;

  BaseAuthorizedState([bottomNavigationSelectedIndex]) {
    if(bottomNavigationSelectedIndex == null){
      this.bottomNavigationSelectedIndex=0;
      isActiveBottomNavigation=false;
    }else{
      this.bottomNavigationSelectedIndex=bottomNavigationSelectedIndex;
    }
  }

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    if (token == null) {
      //to do
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> rout) => false);
    }
  }

  void logout() {
    SharedPreferences.getInstance().then((SharedPreferences val) {
      val.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> rout) => false);
    });
  }

  getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var currentUserJson=sharedPreferences.getString('currentUser');
    if(currentUserJson==null) {
      var url = 'https://apimy.rmto.ir/api/Hambar/getuserinfo';
      var response = await getApiData(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          currentUser = UserModel.fromJson(jsonResponse['data']);
          sharedPreferences.setString('currentUser', currentUser.toJson());
        } else {
          errorBloc.add(ShowErrorEvent('خطا در ارتباط با سرور'));
        }
      }
    }else {
      currentUser = UserModel.fromJson(convert.jsonDecode(currentUserJson));
    }
  }
}
