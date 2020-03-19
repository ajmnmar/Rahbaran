import 'package:flutter/material.dart';
import 'package:rahbaran/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget{
  Home(){
    checkToken();
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('data'),
      ),
    );
  }

  void checkToken() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token')==null){
      //to do
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Login()), (Route<dynamic> rout) => false);
    }
  }
  
}