import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/common/national_code.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/home.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/page/pre_forget_password.dart';
import 'package:rahbaran/page/pre_register.dart';
import 'package:rahbaran/page/validation_base_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'base_state.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends ValidationBaseState<Login> {
  TextStyle flatButtonTextStyle = TextStyle(color: Colors.blue, fontSize: 17);

  //controllers
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //variables
  bool isLoading = false;
  GlobalKey nationalTextFieldKey = GlobalKey();
  double nationalTextFieldHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        nationalTextFieldHeight =
            nationalTextFieldKey.currentContext.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                WidgetHelper.logoHeaderSection(MediaQuery.of(context).size.width),
                loginSection(),
              ],
            ),
          ),
        ),
        WidgetHelper.messageSection(messageOpacity, MediaQuery.of(context).padding.top, message)
      ],
    );
  }

  Widget loginSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextField(
                key: nationalTextFieldKey,
                controller: usernameController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'شماره ملی',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.person,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder)),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: 'کلمه عبور',
                  contentPadding: EdgeInsets.all(7),
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: StyleHelper.iconColor,
                  ),
                  border: StyleHelper.textFieldBorder),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: nationalTextFieldHeight,
            child: RaisedButton(
              onPressed: () {
                loginButtonClicked();
              },
              color: StyleHelper.mainColor,
              shape: StyleHelper.buttonRoundedRectangleBorder,
              child: isLoading
                  ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('ورود', style: StyleHelper.buttonTextStyle),
            ),
          ),
          Visibility(
            visible: validationVisibility,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                validationMessage,
                style: StyleHelper.validationTextStyle,
              ),
            ),
          ),
          alternativeAction(),
        ],
      ),
    );
  }

  Widget alternativeAction() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                forgetPasswordClicked();
              },
              child: Text(
                'فراموشی رمز عبور',
                style: flatButtonTextStyle,
              )),
          Text('/'),
          FlatButton(
              onPressed: () {
                registerClicked();
              },
              child: Text('ثبت نام در سامانه', style: flatButtonTextStyle))
        ],
      ),
    );
  }

  void signIn(String username, String password) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var url =
          'https://apimy.rmto.ir/api/Hambar/Authenticate?username=$username&password=$password';
      var response = await getApiData(url);
      if (response != null){
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          setState(() {
            sharedPreferences.setString('token', jsonResponse['data']['token']);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => News()),
                    (Route<dynamic> rout) => false);
          });
        } else if (jsonResponse['message']['code'] == 6) {
          showValidation('نام کاربری یا رمز عبور اشتباه است');
        }
      }
    }finally{
      setState(() {
        isLoading=false;
      });
    }
  }

  void loginButtonClicked() async{
    hideValidation();
    if (usernameController.text.isEmpty) {
      showValidation('لطفا شماره ملی خود را وارد کنید');
      return;
    } else if (passwordController.text.isEmpty) {
      showValidation('لطفا رمز عبور خود را وارد کنید');
      return;
    } else if (NationalCode.checkNationalCode(
        usernameController.text) ==
        false) {
      showValidation('فرمت شماره ملی اشتباره است');
      return;
    }
    setState(() {
      isLoading = true;
    });

    signIn(usernameController.text, passwordController.text);
  }

  void forgetPasswordClicked(){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => PreForgetPassword())
    );
  }

  void registerClicked() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => PreRegister())
    );
  }
}
