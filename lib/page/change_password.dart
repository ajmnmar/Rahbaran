import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/Widget/logo_header.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/primary_validation.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/common/show_dialog.dart';
import 'package:rahbaran/page/base_authorized_state.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'dart:convert' as convert;

class ChangePassword extends StatefulWidget {
  static const routeName = '/ChangePassword';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends BaseAuthorizedState<ChangePassword> {
  //controllers
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();

  //variables
  ValidationBloc validationBloc = new ValidationBloc();
  LoadingBloc loadingBloc = new LoadingBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('تغییر رمز عبور', style: Theme.of(context).textTheme.title),
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
                changePasswordSection()
              ],
            ),
          ),
        ),
        Message(errorBloc),
      ],
    );
  }

  changePasswordSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.center,
              child: TextField(
                controller: oldPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
                decoration: InputDecoration(
                  hintText: 'کلمه عبور قبلی',
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
            child: BlocBuilder(
                bloc: loadingBloc,
                builder: (context, LoadingState state) {
                  return RaisedButton(
                      onPressed: () {
                        if (state.isLoading) return;
                        changePasswordButtonClicked();
                      },
                      child: state.isLoading
                          ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.white))
                          : Text('تغییر کمله عبور',
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

  void changePasswordButtonClicked() async {
    try {
      validationBloc.add(HideValidationEvent());
      if(oldPasswordController.text.isEmpty){
        validationBloc.add(ShowValidationEvent('لطفا کلمه عبور قبلی را وارد کنید'));
      }else if (passwordController.text.isEmpty) {
        validationBloc.add(ShowValidationEvent('لطفا کلمه عبور جدید را وارد کنید'));
        return;
      } else if (rePasswordController.text.isEmpty) {
        validationBloc
            .add(ShowValidationEvent('لطفا تکرار کلمه عبور جدید را وارد کنید'));
        return;
      } else if (passwordController.text.trim().length < 6) {
        validationBloc
            .add(ShowValidationEvent('کلمه عبور جدید باید حداقل 6 کاراکتر باشد'));
        return;
      } else if (oldPasswordController.text.trim()==passwordController.text.trim()) {
        validationBloc
            .add(ShowValidationEvent('کلمه عبور قدیم با کلمه عبور جدید یکسان است'));
        return;
      } else if (passwordController.text.trim() !=
          rePasswordController.text.trim()) {
        validationBloc
            .add(ShowValidationEvent('رمز عبور جدید و تکرار آن باید یکسان باشند'));
        return;
      }
      loadingBloc.add(LoadingEvent.show);

      var url =
          'https://apimy.rmto.ir/api/Hambar/changepassword?oldpassword=${oldPasswordController.text}&newpassword=${passwordController.text}';
      var response = await postApiData(url,
          headers: {'Authorization': 'Bearer $token',});
      if (response != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message']['code'] == 0) {
          loadingBloc.add(LoadingEvent.hide);
          await ShowDialog.showAlertDialog(context, null, 'عملیات با موفقیت انجام شد');
          Navigator.of(context).pop();
        } else if (jsonResponse['message']['code'] == 2) {
          validationBloc
              .add(ShowValidationEvent('کاربری با این مشخصات پیدا نشد'));
        } else if (jsonResponse['message']['code'] == 8) {
          validationBloc.add(ShowValidationEvent('کلمه عبور اشتباه است'));
        } else {
          validationBloc.add(ShowValidationEvent('خطا در ارتباط با سرور'));
        }
      }
    } finally {
      loadingBloc.add(LoadingEvent.hide);
    }
  }
}
