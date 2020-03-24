import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/common/national_code.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/validation_base_state.dart';

import 'base_state.dart';

class PreForgetPassword extends StatefulWidget {
  @override
  PreForgetPasswordState createState() => PreForgetPasswordState();
}

class PreForgetPasswordState extends ValidationBaseState<PreForgetPassword> {
  //controllers
  TextEditingController nationalCodeController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();

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
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false,
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
              children: <Widget>[headerSection(), forgetPasswordSection()],
            ),
          ),
        ),
        WidgetHelper.messageSection(
            messageOpacity, MediaQuery.of(context).padding.top, message)
      ],
    );
  }

  Widget headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Image.asset(
        "assets/images/logo.png",
        width: MediaQuery.of(context).size.width / 2.8,
      ),
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
                key: nationalTextFieldKey,
                controller: nationalCodeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'راهبران حمل و نقل',
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
            child: Container(
              alignment: Alignment.center,
              child: TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'شماره موبایل',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xff1fd3ae),
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
            height: nationalTextFieldHeight,
            child: RaisedButton(
              onPressed: () {
                forgetButtonClicked();
              },
              color: StyleHelper.mainColor,
              shape: StyleHelper.buttonRoundedRectangleBorder,
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('درخواست تغییر رمز',
                      style: StyleHelper.buttonTextStyle),
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

  void forgetButtonClicked() {
    hideValidation();
    if (nationalCodeController.text.isEmpty) {
      showValidation('لطفا شماره ملی خود را وارد کنید');
      return;
    } else if (mobileController.text.isEmpty) {
      showValidation('لطفا شماره موبایل خود را وارد کنید');
      return;
    } else if (NationalCode.checkNationalCode(nationalCodeController.text) ==
        false) {
      showValidation('فرمت شماره ملی اشتباره است');
      return;
    }
    setState(() {
      isLoading = true;
    });
    //signIn(usernameController.text, passwordController.text);
  }
}
