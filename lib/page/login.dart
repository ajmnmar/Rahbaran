import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/common/national_code.dart';
import 'package:rahbaran/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  Color iconColor = Color(0xff1fd3ae);
  Color mainColor = Color(0xff1fd3ae);
  OutlineInputBorder textFieldBorder =
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7)));
  TextStyle buttonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
  RoundedRectangleBorder buttonRoundedRectangleBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(7));
  TextStyle validationTextStyle = TextStyle(color: Colors.red, fontSize: 17);
  TextStyle flatButtonTextStyle = TextStyle(color: Colors.blue, fontSize: 17);
  TextStyle messageTextStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.normal,
      color: Colors.black,
      decoration: TextDecoration.none);

  //controllers
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //variables
  bool isLoading = false;
  String message = '';
  double messageOpacity = 0;
  Timer messageTimer;
  GlobalKey nationalTextFieldKey = GlobalKey();
  double nationalTextFieldHeight;
  bool validationVisibility = false;
  String validationMessage = '';

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
                headerSection(),
                loginSection(),
              ],
            ),
          ),
        ),
        messageSection()
      ],
    );
  }

  Widget messageSection(){
    return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
            width: double.infinity,
            child: AnimatedOpacity(
              opacity: messageOpacity,
              duration: Duration(milliseconds: 1500),
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top),
                height: 35,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                    message,
                    style: messageTextStyle
                ),
              ),
            )
        )
    );
  }

  Widget headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            child: Image.asset(
              "assets/images/logo.png",
              width: MediaQuery.of(context).size.width / 2.8,
            ),
          ),
          Container(
            child: Text(
              'لطفا شماره ملی و کلمه عبور خود را وارد نمایید',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
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
                    prefixIcon: Icon(
                      Icons.person,
                      color: iconColor,
                    ),
                    border: textFieldBorder)),
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
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: Color(0xff1fd3ae),
                  ),
                  border: textFieldBorder),
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
              },
              color: mainColor,
              shape: buttonRoundedRectangleBorder,
              child: isLoading
                  ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('ورود', style: buttonTextStyle),
            ),
          ),
          Visibility(
            visible: validationVisibility,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                validationMessage,
                style: validationTextStyle,
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
              onPressed: () {},
              child: Text(
                'فراموشی رمز عبور',
                style: flatButtonTextStyle,
              )),
          Text('/'),
          FlatButton(
              onPressed: () {},
              child: Text('ثبت نام در سامانه', style: flatButtonTextStyle))
        ],
      ),
    );
  }

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

  void signIn(String username, String password) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var url =
          'https://apimy.rmto.ir/api/Hambar/Authenticate?username=$username&password=$password';
      var response = await http.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          setState(() {
            sharedPreferences.setString('token', jsonResponse['data']['token']);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => Home()),
                (Route<dynamic> rout) => false);
          });
        } else if (jsonResponse['message']['code'] == 6) {
          showValidation('نام کاربری یا رمز عبور اشتباه است');
        }
      } else {
        showMessage('خطا در اتصال به سرور!');
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        showMessage('خطا در اتصال به اینترنت!');
      } else {
        showMessage('خطا در اتصال به سرور!');
      }
    }finally{
      isLoading=false;
    }
  }
}
