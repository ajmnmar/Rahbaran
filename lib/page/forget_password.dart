import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/Widget/logo_header.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/primary_validation.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/common/show_dialog.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'dart:convert' as convert;

import 'base_state.dart';

class ForgetPassword extends StatefulWidget {
  final String guid;

  ForgetPassword(this.guid);

  @override
  ForgetPasswordState createState() => ForgetPasswordState(guid);
}

class ForgetPasswordState extends BaseState<ForgetPassword> {
  //controllers
  TextEditingController otpController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();

  //variables
  ValidationBloc validationBloc = new ValidationBloc();
  LoadingBloc loadingBloc = new LoadingBloc();
  String guid;


  ForgetPasswordState(this.guid);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('فراموشی رمز عبور',
                style: Theme.of(context).textTheme.title),
            centerTitle: true,
            elevation: 2,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[
                LogoHeader(),
                forgetPasswordSection()
              ],
            ),
          ),
        ),
        Message(errorBloc),
      ],
    );
  }

  Widget forgetPasswordSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                    hintText: 'کد پیامک شده',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.input,
                      color: StyleHelper.iconColor,
                    ),
                    )),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.center,
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                    hintText: 'کلمه عبور جدید',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: StyleHelper.iconColor,
                    ),
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.center,
              child: TextField(
                controller: rePasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                    hintText: 'تکرار کلمه عبور جدید',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: StyleHelper.iconColor,
                    ),
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: StyleHelper.raisedButtonHeight,
            child:BlocBuilder(
                bloc:loadingBloc,
                builder: (context,LoadingState state){
                  return RaisedButton(
                      onPressed: () {
                        if (state.isLoading) return;
                        changePasswordButtonClicked();
                      },
                      child: state.isLoading? CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white)):
                      Text('تایید و تغییر رمز عبور', style: Theme.of(context).textTheme.button));
                }
            ),
          ),
          BlocBuilder(
              bloc: validationBloc,
              builder: (context, ValidationState state) {
                return PrimaryValidation(state.validationVisibility,state.validationMessage);
              }),
        ],
      ),
    );
  }

  void changePasswordButtonClicked() async {
    try {
      validationBloc.add(HideValidationEvent());
      if (otpController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا کدپیامک شده را وارد کنید'));
        return;
      } else if (passwordController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا رمزعبور جدید را وارد کنید'));
        return;
      } else if (rePasswordController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا تکرار رمزعبور جدید را وارد کنید'));
        return;
      } else if (passwordController.text.trim().length < 6) {
        validationBloc.add(ShowValidationEvent('رمز عبور باید حداقل 6 کاراکتر باشد'));
        return;
      } else if (passwordController.text.trim() !=
          rePasswordController.text.trim()) {
        validationBloc.add(ShowValidationEvent('رمز عبور و تکرار آن باید یکسان باشد'));
        return;
      }
      loadingBloc.add(LoadingEvent.show);

      var url =
          'https://apimy.rmto.ir/api/Hambar/ForgetPassword?password=${passwordController.text}&token=$guid&otp=${otpController.text}';
      var response = await postApiData(url);
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          setState(() {
            ShowDialog.showAlertDialog(context, null, 'عملیات با موفقیت انجام شد')
                .then((val) {
              Navigator.of(context).pop();
            });
          });
        } else if (jsonResponse['message']['code'] == 5) {
          validationBloc.add(ShowValidationEvent('کد وارد شده صحیح نیست'));
        } else {
          validationBloc.add(ShowValidationEvent('خطا در ارتباط با سرور'));
        }
      }
    } finally {
      loadingBloc.add(LoadingEvent.hide);
    }
  }
}
