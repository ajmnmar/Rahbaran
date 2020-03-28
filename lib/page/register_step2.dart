import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/common/mobile_mask.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/validation_base_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import 'news.dart';

class RegisterStep2 extends StatefulWidget {
  final String guid;
  final String otp;
  final UserModel userModel;

  RegisterStep2(this.guid, this.otp,this.userModel);

  @override
  RegisterStep2State createState() => RegisterStep2State(this.guid, this.otp,this.userModel);
}

class RegisterStep2State extends ValidationBaseState<RegisterStep2> {
  //controllers
  TextEditingController emailController = new TextEditingController();
  TextEditingController nationalCodeController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();

  //variables
  String guid;
  String otp;
  UserModel userModel;
  bool isLoading = false;
  GlobalKey emailTextFieldKey = GlobalKey();
  double emailTextFieldHeight;

  RegisterStep2State(this.guid, this.otp,this.userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        emailTextFieldHeight = emailTextFieldKey.currentContext.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('ثبت نام', style: StyleHelper.appBarTitleTextStyle),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                WidgetHelper.logoHeaderSection(
                    MediaQuery
                        .of(context)
                        .size
                        .width),
                registerSection()
              ],
            ),
          ),
        ),
        WidgetHelper.messageSection(
            messageOpacity, MediaQuery.of(context).padding.top, message,messageVisibility,(){
          setState(() {
            messageVisibility= messageOpacity==0?false:true;
          });
        })
      ],
    );
  }

  Widget registerSection() {
    return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          margin: EdgeInsets.symmetric(vertical: 20),
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextField(
                    key: emailTextFieldKey,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: 'ایمیل',
                        contentPadding: EdgeInsets.all(7),
                        prefixIcon: Icon(
                          Icons.email,
                          color: StyleHelper.iconColor,
                        ),
                        border: StyleHelper.textFieldBorder)),
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
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        prefixIcon: Icon(
                          Icons.person,
                          color: StyleHelper.iconColor,
                        ),
                        border: StyleHelper.textFieldBorder),
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
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: StyleHelper.iconColor,
                        ),
                        border: StyleHelper.textFieldBorder),
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
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: StyleHelper.iconColor,
                        ),
                        border: StyleHelper.textFieldBorder),
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
                    decoration: InputDecoration(
                        hintText: 'کلمه عبور',
                        contentPadding: EdgeInsets.all(7),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: StyleHelper.iconColor,
                        ),
                        border: StyleHelper.textFieldBorder),
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
                    decoration: InputDecoration(
                        hintText: 'تکرار کلمه عبور',
                        contentPadding: EdgeInsets.all(7),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: StyleHelper.iconColor,
                        ),
                        border: StyleHelper.textFieldBorder),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: emailTextFieldHeight,
                child: RaisedButton(
                  onPressed: () {
                    registerButtonClicked();
                  },
                  color: StyleHelper.mainColor,
                  shape: StyleHelper.buttonRoundedRectangleBorder,
                  child: isLoading
                      ? CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.white))
                      : Text('تایید نهایی', style: StyleHelper.buttonTextStyle),
                ),
              ),
              Visibility(
                visible: validationVisibility,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    validationMessage,
                    style: StyleHelper.validationTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget registerSection1() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextField(
                key: emailTextFieldKey,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'ایمیل',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.email,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder)),
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
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.person,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder),
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
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder),
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
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder),
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
                decoration: InputDecoration(
                    hintText: 'کلمه عبور',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder),
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
                decoration: InputDecoration(
                    hintText: 'تکرار کلمه عبور',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: emailTextFieldHeight,
            child: RaisedButton(
              onPressed: () {
                if(isLoading)
                  return;
                registerButtonClicked();
              },
              color: StyleHelper.mainColor,
              shape: StyleHelper.buttonRoundedRectangleBorder,
              child: isLoading
                  ? CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('تایید نهایی', style: StyleHelper.buttonTextStyle),
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
        ],
      ),
    );
  }

  void registerButtonClicked() async {
    try {
      hideValidation();
      if (passwordController.text.isEmpty) {
        showValidation('لطفا کلمه عبور را وارد کنید');
        return;
      } else if (rePasswordController.text.isEmpty) {
        showValidation('لطفا تکرار کلمه عبور را وارد کنید');
        return;
      } else if (passwordController.text.trim().length < 6) {
        showValidation('کلمه عبور باید حداقل 6 کاراکتر باشد');
        return;
      } else if (passwordController.text.trim() !=
          rePasswordController.text.trim()) {
        showValidation('رمز عبور و تکرار آن باید یکسان باشد');
        return;
      }
      setState(() {
        isLoading = true;
      });

      var url =
          'https://apimy.rmto.ir/api/Hambar/RegistrationStep2?password=${passwordController.text}&token=$guid&otp=$otp';
      var response = await postApiData(url,headers:{"Content-Type": "application/json"},body:userModel.toJson());
      if (response != null){
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('token', jsonResponse['data']['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => News()),
                  (Route<dynamic> rout) => false);
        }else if (jsonResponse['message']['code'] == 1) {
          showValidation('برای این کاربر شماره موبایل ثبت نشده است');
        }else if (jsonResponse['message']['code'] == 2) {
          showValidation('کاربری با این مشخصات پیدا نشد');
        } else if (jsonResponse['message']['code'] == 3) {
          showValidation('شما با شماره موبایل ${MobileMask.changeMobileMaskDirection(jsonResponse['data'])} در سامانه مرکزی ثبت نام کرده اید');
        }else if (jsonResponse['message']['code'] == 5) {
          showValidation('کد فعال سازی اشتباه است');
        }else{
          showValidation('خطا در ارتباط با سرور');
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
