import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/register_step2.dart';
import 'package:rahbaran/page/validation_base_state.dart';
import 'dart:convert' as convert;

class RegisterStep1 extends StatefulWidget {
  final String guid;

  RegisterStep1(this.guid);

  @override
  RegisterStep1State createState() => RegisterStep1State(guid);
}

class RegisterStep1State extends ValidationBaseState<RegisterStep1> {
  //const
  static const otpLength = 6;

  //controllers
  TextEditingController otpController = new TextEditingController();

  //variables
  String guid;
  bool isLoading = false;
  GlobalKey otpTextFieldKey = GlobalKey();
  double otpTextFieldHeight;

  RegisterStep1State(this.guid);

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
                    MediaQuery.of(context).size.width),
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
                key: otpTextFieldKey,
                controller: otpController,
                onChanged: (val) {
                  if (val.length == otpLength) {
                    register();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: otpLength,
                decoration: InputDecoration(
                    hintText: 'کد فعال سازی',
                    contentPadding: EdgeInsets.all(7),
                    counterText: "",
                    prefixIcon: Icon(
                      Icons.input,
                      color: StyleHelper.iconColor,
                    ),
                    border: StyleHelper.textFieldBorder)),
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
                register();
              },
              color: StyleHelper.mainColor,
              shape: StyleHelper.buttonRoundedRectangleBorder,
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('تایید و ادامه', style: StyleHelper.buttonTextStyle),
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

  void register() async {
    try {
      hideValidation();
      if (otpController.text.isEmpty) {
        showValidation('لطفا کد فعال سازی را وارد کنید');
        return;
      }
      setState(() {
        isLoading = true;
      });

      var url =
          'https://apimy.rmto.ir/api/Hambar/RegistrationStep1?token=$guid&otp=${otpController.text}';
      var response = await getApiData(url);
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          setState(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => RegisterStep2(
                    guid,
                    otpController.text,
                    UserModel.fromJson(jsonResponse['data']))));
          });
        } else if (jsonResponse['message']['code'] == 5) {
          showValidation('کد فعال سازی اشتباه است');
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
