import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PreForgetPassword extends StatefulWidget {
  @override
  PreForgetPasswordState createState() => PreForgetPasswordState();
}

class PreForgetPasswordState extends State<PreForgetPassword> {
  //styles
  Color iconColor = Color(0xff1fd3ae);
  Color mainColor = Color(0xff1fd3ae);
  OutlineInputBorder textFieldBorder =
  OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7)));
  TextStyle buttonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
  RoundedRectangleBorder buttonRoundedRectangleBorder =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(7));
  TextStyle headerTextStyle=TextStyle(fontSize: 14,color: Colors.grey);

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
            title: Text('فراموشی رمز عبور'),
            centerTitle: true,
            elevation: 2,
          ),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                headerSection(),
                forgetPasswordSection()
              ],
            ),
          ),
        ),
        //messageSection()
      ],
    );
  }

  Widget headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Image.asset(
            "assets/images/logo.png",
            width: MediaQuery.of(context).size.width / 2.8,
          ),
          Text(
            'راهبران حمل و نقل',
            style: headerTextStyle,
          ),
        ],
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
                    hintText: 'شماره ملی',
                    prefixIcon: Icon(
                      Icons.person,
                      color: iconColor,
                    ),
                    border: textFieldBorder)),
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
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xff1fd3ae),
                    ),
                    border: textFieldBorder),
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
                /*hideValidation();
                if (usernameController.text.isEmpty) {
                  showValidation('لطفا شماره ملی خود را وارد کنید');
                  return;
                } else if (passwordController.text.isEmpty) {
                  showValidation('لطفا رمز عبور خود را وارد کنید');
                  return;
                } else if (NationalCode.checkNationalCode(
                    usernameController.text) ==
                    false) {
                  showValidation('فرمت شماره ملی اشتباره است');
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                signIn(usernameController.text, passwordController.text);*/
              },
              color: mainColor,
              shape: buttonRoundedRectangleBorder,
              child: isLoading
                  ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('درخواست تغییر رمز', style: buttonTextStyle),
            ),
          ),
          /*Visibility(
            visible: validationVisibility,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                validationMessage,
                style: validationTextStyle,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
