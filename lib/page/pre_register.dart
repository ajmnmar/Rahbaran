import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/common/mobile_mask.dart';
import 'package:rahbaran/page/register_step1.dart';

import '../common/national_code.dart';
import '../theme/style_helper.dart';
import '../helper/widget_helper.dart';
import 'base_state.dart';
import 'dart:convert' as convert;

class PreRegister extends StatefulWidget {
  @override
  PreRegisterState createState() => PreRegisterState();
}

class PreRegisterState extends BaseState<PreRegister> {
  //controllers
  TextEditingController nationalCodeController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();

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
                  key: nationalTextFieldKey,
                  controller: nationalCodeController,
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
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                  decoration: InputDecoration(
                      hintText: 'شماره موبایل',
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
                          registerButtonClicked();
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
      ),
    );
  }

  void registerButtonClicked() async {
    try {
      validationBloc.add(HideValidationEvent());
      if (nationalCodeController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا شماره ملی خود را وارد کنید'));
        return;
      } else if (mobileController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا شماره موبایل خود را وارد کنید'));
        return;
      } else if (NationalCode.checkNationalCode(nationalCodeController.text) ==
          false) {
        validationBloc.add(ShowValidationEvent('فرمت شماره ملی اشتباره است'));
        return;
      }
      loadingBloc.add(LoadingEvent.show);

      var url =
          'https://apimy.rmto.ir/api/Hambar/PreRegistration?nationalCode=${nationalCodeController.text}&mobileNumber=${mobileController.text}';
      var response = await getApiData(url);
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          setState(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    RegisterStep1(jsonResponse['data'])));
          });
        } else if (jsonResponse['message']['code'] == 1) {
          validationBloc.add(ShowValidationEvent('برای این کاربر شماره موبایل ثبت نشده است'));
        } else if (jsonResponse['message']['code'] == 2) {
          validationBloc.add(ShowValidationEvent('کاربری با این مشخصات پیدا نشد'));
        } else if (jsonResponse['message']['code'] == 3) {
          validationBloc.add(ShowValidationEvent('شما با شماره موبایل ${MobileMask.changeMobileMaskDirection(jsonResponse['data'])} در سامانه مرکزی ثبت نام کرده اید'));
        } else if (jsonResponse['message']['code'] == 4) {
          validationBloc.add(ShowValidationEvent('کاربر با این مشخصات پیشتر ثبت نام کرده است'));
        } else {
          validationBloc.add(ShowValidationEvent('خطا در ارتباط با سرور'));
        }
      }
    } finally {
      loadingBloc.add(LoadingEvent.hide);
    }
  }
}
