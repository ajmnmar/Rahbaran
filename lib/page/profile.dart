import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/Widget/primary_validation.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/bloc/validation_bloc.dart';
import 'package:rahbaran/page/base_authorized_state.dart';
import 'package:rahbaran/theme/style_helper.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends BaseAuthorizedState<Profile> {
  //controllers
  TextEditingController emailController = new TextEditingController();
  TextEditingController nationalCodeController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController smartCardDateController = new TextEditingController();

  //variables
  LoadingBloc loadingBloc = new LoadingBloc();
  LoadingBloc buttonLoadingBloc = new LoadingBloc();
  ValidationBloc validationBloc = new ValidationBloc();
  double fieldHeight=48;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadingBloc.add(LoadingEvent.show);
    getToken().then((val) {
      getCurrentUser().then((val) {
        setState(() {
          nationalCodeController.text = currentUser.nationalCode;
          emailController.text = currentUser.email;
          mobileController.text = currentUser.mobile;
          smartCardDateController.text = '';

          loadingBloc.add(LoadingEvent.hide);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('اطلاعات کاربری'),
            centerTitle: true,
            elevation: 2,
          ),
          drawer: PrimaryDrawer(currentUser: currentUser,logout: logout,),
          body: BlocBuilder(
              bloc: loadingBloc,
              builder: (context, LoadingState state) {
                return profileBody(state);
              }),
          bottomNavigationBar:
              MainBottomNavigationBar(bottomNavigationSelectedIndex),
        ),
        Message(errorBloc),
      ],
    );
  }

  profileBody(LoadingState state) {
    if (state.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(StyleHelper.mainColor)));
    } else {
      return Container(
        margin: StyleHelper.primaryContainerMargin,
        child: ListView(
          padding: StyleHelper.primaryContainerPadding,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: min(MediaQuery.of(context).size.width / 6, 60),
                      backgroundColor: Colors.white,
                      backgroundImage: (currentUser == null ||
                              currentUser.userImageAddress == null ||
                              currentUser.userImageAddress.isEmpty)
                          ? Image.asset('assets/images/driverempty.png').image
                          : NetworkImage(currentUser.userImageAddress),
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: min(MediaQuery.of(context).size.width / 3, 120),
                      width: min(MediaQuery.of(context).size.width / 3, 120),
                      child: CircleAvatar(
                        radius: min(MediaQuery.of(context).size.width / 10, 20),
                        backgroundColor: Colors.white,
                        backgroundImage:
                            Image.asset('assets/images/edit-48.png').image,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: (currentUser.fullName == null ||
                      currentUser.fullName.isEmpty)
                  ? Text('')
                  : Text(
                      currentUser.fullName + ' / ' + currentUser.userModeName(),
                      style: Theme.of(context).textTheme.caption,
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
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
            Container(
              margin: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
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
            Container(
              margin: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: smartCardDateController,
                  enabled: false,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                  decoration: InputDecoration(
                    hintText: 'تاریخ اعتبار کارت هوشمند',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.credit_card,
                      color: StyleHelper.iconColor,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: emailController,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                  decoration: InputDecoration(
                    hintText: 'ایمیل',
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(
                      Icons.email,
                      color: StyleHelper.iconColor,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: SizedBox(
                width: double.infinity,
                height: fieldHeight,
                child: BlocBuilder(
                    bloc: buttonLoadingBloc,
                    builder: (context, LoadingState state) {
                      return RaisedButton(
                          onPressed: () {
                            if (state.isLoading) return;
                            saveButtonClicked();
                          },
                          child: state.isLoading
                              ? CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white))
                              : Text('ذخیره سازی',
                                  style: Theme.of(context).textTheme.button));
                    }),
              ),
            ),
            BlocBuilder(
                bloc: validationBloc,
                builder: (context, ValidationState state) {
                  return PrimaryValidation(
                      state.validationVisibility, state.validationMessage);
                }),
            alternativeAction(),
          ],
        ),
      );
    }
  }

  alternativeAction() {
    return Container(
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            changePasswordClicked();
          },
          child: Text(
            'تغییر رمزعبور',
            textAlign: TextAlign.center,
            style: StyleHelper.loginFlatButtonTextStyle,
          )),
    );
  }

  void saveButtonClicked() {}

  void changePasswordClicked() {}
}
