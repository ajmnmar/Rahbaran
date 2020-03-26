import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/validation_base_state.dart';

class Test extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
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
  bool isLoading = false;
  GlobalKey emailTextFieldKey = GlobalKey();
  double emailTextFieldHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        emailTextFieldHeight = emailTextFieldKey.currentContext.size.height;
      });
    });*/
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
                children: <Widget>[
                  WidgetHelper.logoHeaderSection(
                      MediaQuery.of(context).size.width),
                  Expanded(
                    child: ListView(
                      //scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Text('data'),
                        Text('data'),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
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
                          width: double.infinity,
                          child: TextField(
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
                          width: double.infinity,
                          child: TextField(
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
                          width: double.infinity,
                          child: TextField(
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
                          width: double.infinity,
                          child: TextField(
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
                          width: double.infinity,
                          child: TextField(
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

                        /*WidgetHelper.logoHeaderSection(
                      MediaQuery.of(context).size.width),*/
                      ],
                    ),
                  )
                ],
              )

              /*body: SingleChildScrollView(
              child: Container(
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
            )*/
              ),
        ),
        /*WidgetHelper.messageSection(
            messageOpacity, MediaQuery.of(context).padding.top, message)*/
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
                //registerButtonClicked();
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
          /*Visibility(
            visible: validationVisibility,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                validationMessage,
                style: StyleHelper.validationTextStyle,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
