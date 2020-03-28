import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final int httpRequestTimeout = 10;

  String token;
  String message = '';
  double messageOpacity = 0;
  bool messageVisibility = false;
  Timer messageTimer;
  UserModel currentUser;

  void showMessage(String message) {
    if (messageTimer != null) {
      messageTimer.cancel();
    }
    setState(() {
      this.message = message;
      this.messageOpacity = 1;
      this.messageVisibility = true;
    });
    messageTimer = new Timer(Duration(seconds: 3), () {
      setState(() {
        this.messageOpacity = 0;
      });
    });
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
    var url = 'https://apimy.rmto.ir/api/Hambar/getuserinfo';
    var response = await getApiData(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response != null) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        currentUser = UserModel.fromJson(jsonResponse['data']);
      } else {
        showMessage('خطا در ارتباط با سرور');
      }
    }
  }

  getApiData(String url, {Map<String, String> headers}) async {
    http.Response response;
    try {
      response = await http
          .get(url, headers: headers)
          .timeout(Duration(seconds: httpRequestTimeout));
      if (response.statusCode == 401) {
        logout();
      } else if (response.statusCode != 200) {
        showMessage('خطا در اتصال به سرور!');
      }
    } on Exception catch (e) {
      if (e is SocketException || e is TimeoutException) {
        showMessage('خطا در اتصال به اینترنت!');
      } else {
        showMessage('خطا در اتصال به سرور!');
      }
    }
    return response;
  }

  postApiData(String url, {Map<String, String> headers, String body}) async {
    http.Response response;
    try {
      if (body.isEmpty)
        response =
            await http.post(url).timeout(Duration(seconds: httpRequestTimeout));
      else
        response = await http
            .post(url, headers: headers, body: body)
            .timeout(Duration(seconds: httpRequestTimeout));
      if (response.statusCode != 200) {
        showMessage('خطا در اتصال به سرور!');
      }
    } on Exception catch (e) {
      if (e is SocketException || e is TimeoutException) {
        showMessage('خطا در اتصال به اینترنت!');
      } else {
        showMessage('خطا در اتصال به سرور!');
      }
    }
    return response;
  }

  Widget mainDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            color: StyleHelper.mainColor,
            height: 150,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: min(85, MediaQuery.of(context).size.width / 2.5),
                  width: min(85, MediaQuery.of(context).size.width / 2.5),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: (currentUser == null ||
                            currentUser.userImageAddress == null ||
                            currentUser.userImageAddress.isEmpty)
                        ? Image.asset('assets/images/driverempty.png').image
                        : NetworkImage(currentUser.userImageAddress),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: (currentUser == null ||
                          currentUser.fullName == null ||
                          currentUser.fullName.isEmpty)
                      ? Text('')
                      : Text(currentUser.fullName +
                          ' / ' +
                          currentUser.userModeName()),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              'اخبار',
              style: StyleHelper.drawerItemTextStyle,
            ),
            leading: Icon(
              Icons.mail,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'لیست ناوگان',
              style: StyleHelper.drawerItemTextStyle,
            ),
            leading: Icon(
              Icons.local_shipping,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'لیست اسناد حمل',
              style: StyleHelper.drawerItemTextStyle,
            ),
            leading: Icon(
              Icons.description,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'درباره ما',
              style: StyleHelper.drawerItemTextStyle,
            ),
            leading: Icon(
              Icons.info,
              color: StyleHelper.iconColor,
            ),
          ),
          ListTile(
            title: Text(
              'خروج',
              style: StyleHelper.drawerItemTextStyle,
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: StyleHelper.iconColor,
            ),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}
