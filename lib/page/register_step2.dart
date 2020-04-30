import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/Widget/logo_header.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/primary_validation.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/common/mobile_mask.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/page/argument/register_step2_argument.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'base_state.dart';
import 'news.dart';

class RegisterStep2 extends StatefulWidget {
  static const routeName = '/RegisterStep2';

  RegisterStep2();

  @override
  RegisterStep2State createState() => RegisterStep2State();
}

class RegisterStep2State extends BaseState<RegisterStep2> {
  //controllers
  TextEditingController emailController = new TextEditingController();
  TextEditingController nationalCodeController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();

  //variables
  ValidationBloc validationBloc = new ValidationBloc();
  LoadingBloc loadingBloc = new LoadingBloc();
  RegisterStep2Argument registerStep2Argument;

  @override
  Widget build(BuildContext context) {
    registerStep2Argument = ModalRoute.of(context).settings.arguments;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('ثبت نام', style: Theme.of(context).textTheme.title),
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
              children: <Widget>[LogoHeader(), registerSection()],
            ),
          ),
        ),
        Message(errorBloc),
      ],
    );
  }

  Widget registerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  hintText: 'ایمیل',
                  contentPadding: EdgeInsets.all(7),
                  prefixIcon: Icon(
                    Icons.email,
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
                controller: nationalCodeController,
                enabled: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  prefixIcon: Icon(
                    Icons.person,
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
                controller: nameController,
                enabled: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  prefixIcon: Icon(
                    Icons.perm_identity,
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
                controller: mobileController,
                enabled: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  prefixIcon: Icon(
                    Icons.phone,
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
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  hintText: 'کلمه عبور',
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
                  hintText: 'تکرار کلمه عبور',
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
            child: BlocBuilder(
                bloc: loadingBloc,
                builder: (context, LoadingState state) {
                  return RaisedButton(
                      onPressed: () {
                        if (state.isLoading) return;
                        registerButtonClicked();
                      },
                      child: state.isLoading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white))
                          : Text('تایید نهایی',
                              style: Theme.of(context).textTheme.button));
                }),
          ),
          BlocBuilder(
              bloc: validationBloc,
              builder: (context, ValidationState state) {
                return PrimaryValidation(
                    state.validationVisibility, state.validationMessage);
              }),
        ],
      ),
    );
  }

  void registerButtonClicked() async {
    try {
      validationBloc.add(HideValidationEvent());
      if (passwordController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا کلمه عبور را وارد کنید'));
        return;
      } else if (rePasswordController.text.isEmpty) {
        validationBloc
            .add(ShowValidationEvent('لطفا تکرار کلمه عبور را وارد کنید'));
        return;
      } else if (passwordController.text.trim().length < 6) {
        validationBloc
            .add(ShowValidationEvent('کلمه عبور باید حداقل 6 کاراکتر باشد'));
        return;
      } else if (passwordController.text.trim() !=
          rePasswordController.text.trim()) {
        validationBloc
            .add(ShowValidationEvent('رمز عبور و تکرار آن باید یکسان باشد'));
        return;
      }
      loadingBloc.add(LoadingEvent.show);

      var url =
          'https://apimy.rmto.ir/api/Hambar/RegistrationStep2?password=${passwordController.text}&token=${registerStep2Argument.guid}&otp=${registerStep2Argument.otp}';
      var response = await postApiData(url,
          headers: {"Content-Type": "application/json"},
          body: registerStep2Argument.userModel.toJson());
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('token', jsonResponse['data']['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => News()),
              (Route<dynamic> rout) => false);
        } else if (jsonResponse['message']['code'] == 1) {
          validationBloc.add(
              ShowValidationEvent('برای این کاربر شماره موبایل ثبت نشده است'));
        } else if (jsonResponse['message']['code'] == 2) {
          validationBloc
              .add(ShowValidationEvent('کاربری با این مشخصات پیدا نشد'));
        } else if (jsonResponse['message']['code'] == 3) {
          validationBloc.add(ShowValidationEvent(
              'شما با شماره موبایل ${MobileMask.changeMobileMaskDirection(jsonResponse['data'])} در سامانه مرکزی ثبت نام کرده اید'));
        } else if (jsonResponse['message']['code'] == 5) {
          validationBloc.add(ShowValidationEvent('کد فعال سازی اشتباه است'));
        } else {
          validationBloc.add(ShowValidationEvent('خطا در ارتباط با سرور'));
        }
      }
    } finally {
      loadingBloc.add(LoadingEvent.hide);
    }
  }
}
