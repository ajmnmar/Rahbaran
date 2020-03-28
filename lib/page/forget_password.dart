import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/common/ShowDialog.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/validation_base_state.dart';
import 'dart:convert' as convert;

class ForgetPassword extends StatefulWidget {
  final String guid;

  ForgetPassword(this.guid);

  @override
  ForgetPasswordState createState() => ForgetPasswordState(guid);
}

class ForgetPasswordState extends ValidationBaseState<ForgetPassword> {
  //controllers
  TextEditingController otpController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();

  //variables
  String guid;
  bool isLoading = false;
  GlobalKey otpTextFieldKey = GlobalKey();
  double otpTextFieldHeight;

  ForgetPasswordState(this.guid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        otpTextFieldHeight = otpTextFieldKey.currentContext.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('فراموشی رمز عبور',
                style: StyleHelper.appBarTitleTextStyle),
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
                    MediaQuery.of(context).size.width),
                forgetPasswordSection()
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

  Widget forgetPasswordSection() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: TextField(
                  key: otpTextFieldKey,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'کد پیامک شده',
                      contentPadding: EdgeInsets.all(7),
                      prefixIcon: Icon(
                        Icons.input,
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
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'کلمه عبور جدید',
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
                      hintText: 'تکرار کلمه عبور جدید',
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
              height: otpTextFieldHeight,
              child: RaisedButton(
                onPressed: () {
                  if (isLoading) return;
                  changePasswordButtonClicked();
                },
                color: StyleHelper.mainColor,
                shape: StyleHelper.buttonRoundedRectangleBorder,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text('تایید و تغییر رمز عبور',
                        style: StyleHelper.buttonTextStyle),
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
      ),
    );
  }

  void changePasswordButtonClicked() async {
    try {
      hideValidation();
      if (otpController.text.isEmpty) {
        showValidation('لطفا کدپیامک شده را وارد کنید');
        return;
      } else if (passwordController.text.isEmpty) {
        showValidation('لطفا رمزعبور جدید را وارد کنید');
        return;
      } else if (rePasswordController.text.isEmpty) {
        showValidation('لطفا تکرار رمزعبور جدید را وارد کنید');
        return;
      } else if (passwordController.text.trim().length < 6) {
        showValidation('رمز عبور باید حداقل 6 کاراکتر باشد');
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
          'https://apimy.rmto.ir/api/Hambar/ForgetPassword?password=${passwordController.text}&token=$guid&otp=${otpController.text}';
      var response = await postApiData(url);
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          setState(() {
            ShowDialog.showOkDialog(context, null, 'عملیات با موفقیت انجام شد')
                .then((val) {
              Navigator.of(context).pop();
            });
          });
        } else if (jsonResponse['message']['code'] == 5) {
          showValidation('کد وارد شده صحیح نیست');
        } else {
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
