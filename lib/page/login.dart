import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rahbaran/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  Color iconColor = Color(0xff1fd3ae);
  Color mainColor = Color(0xff1fd3ae);
  OutlineInputBorder textFieldBorder =
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40)));
  TextStyle buttonTextStyle = TextStyle(color: Colors.white, fontSize: 20);

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection()
                ],
              ),
      ),
    );
  }

  Widget headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Image.asset(
              "assets/images/logo.png",
              width: MediaQuery.of(context).size.width / 2.5,
            ),
          ),
          Container(
            child: Text(
              'لطفا شماره ملی و کلمه عبور خود را وارد نمایید',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          TextField(
              controller: usernameController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  labelText: 'شماره ملی',
                  prefixIcon: Icon(
                    Icons.person,
                    color: iconColor,
                  ),
                  border: textFieldBorder)),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                labelText: 'کلمه عبور',
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: Color(0xff1fd3ae),
                ),
                border: textFieldBorder),
          ),
        ],
      ),
    );
  }

  Widget buttonSection() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: RaisedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              signIn(usernameController.text, passwordController.text);
            },
            color: mainColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Text('ورود', style: buttonTextStyle),
          ),
        ),
      ),
    );
  }

  void signIn(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url =
        'https://apimy.rmto.ir/api/Hambar/Authenticate?username=$username&password=$password';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        setState(() {
          sharedPreferences.setString('token', jsonResponse['data']['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Home()),
              (Route<dynamic> rout) => false);
        });
      } else {
        //to do
      }
    } else {
      //to do
    }
  }
}
