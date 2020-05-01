import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/token_model.dart';
import 'package:rahbaran/page/about_us.dart';
import 'package:rahbaran/page/change_password.dart';
import 'package:rahbaran/page/forget_password.dart';
import 'package:rahbaran/page/freighter.dart';
import 'package:rahbaran/page/freighter_details.dart';
import 'package:rahbaran/page/login_rule.dart';
import 'package:rahbaran/page/pre_register.dart';
import 'package:rahbaran/page/profile.dart';
import 'package:rahbaran/page/register_step1.dart';
import 'package:rahbaran/page/shipping_document.dart';
import 'package:rahbaran/page/shipping_document_details.dart';
import 'package:rahbaran/page/splash_screen.dart';
import 'package:rahbaran/page/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/page/news_details.dart';
import 'package:rahbaran/page/pre_forget_password.dart';
import 'package:rahbaran/page/register_step2.dart';
import 'package:rahbaran/repository/database_helper.dart';
import 'package:rahbaran/repository/token_repository.dart';
import 'package:rahbaran/theme/basic_theme.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fa'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'راهبران حمل و نقل',
      theme: basicTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        AboutUs.routeName: (context) => AboutUs(),
        ChangePassword.routeName: (context) => ChangePassword(),
        ForgetPassword.routeName: (context) => ForgetPassword(),
        Freighter.routeName: (context) => Freighter(),
        FreighterDetails.routeName:(context) => FreighterDetails(),
        Login.routeName:(context) => Login(),
        LoginRule.routeName:(context) => LoginRule(),
        News.routeName:(context) => News(),
        NewsDetails.routeName:(context) => NewsDetails(),
        PreForgetPassword.routeName:(context) => PreForgetPassword(),
        PreRegister.routeName:(context) => PreRegister(),
        Profile.routeName:(context) => Profile(),
        RegisterStep1.routeName:(context) => RegisterStep1(),
        RegisterStep2.routeName:(context) => RegisterStep2(),
        ShippingDocument.routeName:(context) => ShippingDocument(),
        ShippingDocumentDetails.routeName:(context) => ShippingDocumentDetails(),
      },
      //home: SplashScreen(),
    );
  }
}
