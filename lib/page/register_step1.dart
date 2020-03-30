import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/data_model/user_model.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/register_step2.dart';
import 'dart:convert' as convert;

import 'base_state.dart';

class RegisterStep1 extends StatefulWidget {
  final String guid;

  RegisterStep1(this.guid);

  @override
  RegisterStep1State createState() => RegisterStep1State(guid);
}

class RegisterStep1State extends BaseState<RegisterStep1> {
  //const
  static const otpLength = 6;

  //controllers
  TextEditingController otpController = new TextEditingController();

  //variables
  ValidationBloc validationBloc = new ValidationBloc();
  LoadingBloc loadingBloc = new LoadingBloc();
  String guid;
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
        messageSection(errorBloc),
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
                style: Theme.of(context).textTheme.caption,
                maxLength: otpLength,
                decoration: InputDecoration(
                    hintText: 'کد فعال سازی',
                    contentPadding: EdgeInsets.all(7),
                    counterText: "",
                    prefixIcon: Icon(
                      Icons.input,
                      color: StyleHelper.iconColor,
                    ),
                    )),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: otpTextFieldHeight,
            child: BlocBuilder(
                bloc:loadingBloc,
                builder: (context,LoadingState state){
                  return RaisedButton(
                      onPressed: () {
                        if (state.isLoading) return;
                        register();
                      },
                      child: state.isLoading? CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white)):
                      Text('تایید و ادامه', style: Theme.of(context).textTheme.button));
                }
            ),
          ),
          BlocBuilder(
              bloc: validationBloc,
              builder: (context, ValidationState state) {
                return Visibility(
                  visible: state.validationVisibility,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      state.validationMessage,
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                );
              }),
        ],
      ),
    ));
  }

  void register() async {
    try {
      validationBloc.add(HideValidationEvent());
      if (otpController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا کد فعال سازی را وارد کنید'));
        return;
      }
      loadingBloc.add(LoadingEvent.show);

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
