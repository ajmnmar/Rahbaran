import 'package:flutter/material.dart';
import 'package:rahbaran/page/login.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/repository/database_helper.dart';
import 'package:rahbaran/repository/token_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
        ),
      ),
    );
  }

  void checkToken() async {
    try {

      //get token from db
      var db=await DatabaseHelper().database;
      var tokenModelList=await TokenRepository(db).get();
      if(tokenModelList!=null && tokenModelList.length>0) {
        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
        sharedPreferences.setString('token', tokenModelList.last.token);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => News()),
                (Route<dynamic> rout) => false);
      }else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login()),
                (Route<dynamic> rout) => false);
      }
    }on Exception catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
              (Route<dynamic> rout) => false);
    }
  }
}
