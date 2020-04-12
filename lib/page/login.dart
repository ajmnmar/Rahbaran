import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/Widget/logo_header.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/primary_validation.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/common/national_code.dart';
import 'package:rahbaran/page/login_help.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/page/pre_forget_password.dart';
import 'package:rahbaran/page/pre_register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'base_state.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends BaseState<Login> {
  //style
  TextStyle loginFlatButtonTextStyle =
  TextStyle(color: Colors.blue, fontSize: 16);
  TextStyle loginFlatButtonSeparatorTextStyle =
  TextStyle(color: Colors.black, fontSize: 16);

  //controllers
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //variables
  ValidationBloc validationBloc = new ValidationBloc();
  LoadingBloc loadingBloc = new LoadingBloc();
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
          body: Container(
            alignment: Alignment.topCenter,
            child: ListView(
              children: <Widget>[
                LogoHeader(40),
                loginSection(),
              ],
            ),
          ),
        ),
        Message(errorBloc),      ],
    );
  }

  Widget loginSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextField(
                key: nationalTextFieldKey,
                controller: usernameController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  hintText: 'شماره ملی',
                  contentPadding: EdgeInsets.all(7),
                  prefixIcon: Icon(
                    Icons.person,
                    color: StyleHelper.iconColor,
                  ),
                )),
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
              style: Theme.of(context).textTheme.caption,
              decoration: InputDecoration(
                hintText: 'کلمه عبور',
                contentPadding: EdgeInsets.all(7),
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: StyleHelper.iconColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: nationalTextFieldHeight,
            child: BlocBuilder(
                bloc:loadingBloc,
                builder: (context,LoadingState state){
                  return RaisedButton(
                      onPressed: () {
                        if (state.isLoading) return;
                        loginButtonClicked();
                      },
                      child: state.isLoading? CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white)):
                      Text('ورود', style: Theme.of(context).textTheme.button));
                }
            ),
          ),
          BlocBuilder(
              bloc: validationBloc,
              builder: (context, ValidationState state) {
                return PrimaryValidation(state.validationVisibility,state.validationMessage);
              }),
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
          Expanded(
            flex: 2,
            child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  loginHelpClicked();
                },
                child: Text(
                  'راهنما',
                  textAlign: TextAlign.center,
                  style: loginFlatButtonTextStyle,
                )),
          ),
          Text('/',textAlign: TextAlign.center,
            style: loginFlatButtonSeparatorTextStyle,),
          Expanded(
            flex: 4,
            child: FlatButton(
                //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  forgetPasswordClicked();
                },
                child: Text(
                  'فراموشی رمزعبور',
                  textAlign: TextAlign.center,
                  style: loginFlatButtonTextStyle,
                )),
          ),
          Text('/',textAlign: TextAlign.center,
            style: loginFlatButtonSeparatorTextStyle,),
          Expanded(
            flex: 5,
            child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  registerClicked();
                },
                child: Text('ثبت نام در سامانه',
                    textAlign: TextAlign.center,
                    style: loginFlatButtonTextStyle)
            ),
          )
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
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          sharedPreferences.setString('token', jsonResponse['data']['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => News()),
                  (Route<dynamic> rout) => false);
        } else if (jsonResponse['message']['code'] == 6) {
          validationBloc.add(ShowValidationEvent('نام کاربری یا رمز عبور اشتباه است'));
        }
      }
    } finally {
      loadingBloc.add(LoadingEvent.hide);
    }
  }

  void loginButtonClicked() async {
    validationBloc.add(HideValidationEvent());
    if (usernameController.text.isEmpty) {
      validationBloc.add(ShowValidationEvent('لطفا شماره ملی خود را وارد کنید'));
      return;
    } else if (passwordController.text.isEmpty) {
      validationBloc.add(ShowValidationEvent('لطفا رمز عبور خود را وارد کنید'));
      return;
    } else if (NationalCode.checkNationalCode(usernameController.text) ==
        false) {
      validationBloc.add(ShowValidationEvent('فرمت شماره ملی اشتباره است'));
      return;
    }
    loadingBloc.add(LoadingEvent.show);

    signIn(usernameController.text, passwordController.text);
  }

  void forgetPasswordClicked() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PreForgetPassword()));
  }

  void registerClicked() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => PreRegister()));
  }

  void loginHelpClicked() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LoginHelp()));
  }
}
