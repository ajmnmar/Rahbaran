import 'package:flutter/material.dart';
import 'package:rahbaran/Widget/logo_header.dart';

class LoginRule extends StatelessWidget {
  static const routeName = '/LoginRule';

  final helpContext='اپلیکیشن راهبران حمل و نقل خدمتی است از سازمان راهداری و حمل و نقل جاده ای به رانندگان و صاحبان ناوگان کشور.'+
  ' رانندگان و صاحبان ناوگان می توانند با استفاده از این اپلیکیشن به خدمات متنوع سازمان راهداری و حمل و نقل جاده ای دسترسی داشته باشند.'+
  '\n'+
  'رانندگان و صاحبان ناوگانی که در سامانه کارت هوشمند ثبت نام کرده اند می توانند از طریق شماره ملی و شماره تلفن همراهی که در آن سامانه اعلام کرده اند در سامانه راهبران حمل و نقل وارد شوند.'+
  '\n'+
  'ورود از طریق شماره ملی و شماره تلفن همراه جهت تطابق اطلاعات با سامانه کارت هوشمند و ارائه خدمات به راننده و صاحب ناوگان شناسایی شده از سوی سازمان راهداری و حمل و نقل جاده ای ضروری است.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قوانین و مقررات', style: Theme.of(context).textTheme.title),
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
            helpSection(context)
          ],
        ),
      ),
    );
  }

  helpSection(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: new Text(
        helpContext,
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
