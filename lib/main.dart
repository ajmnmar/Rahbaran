import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/token_model.dart';
import 'package:rahbaran/page/forget_password.dart';
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
        title: 'Flutter Demo',
        theme: basicTheme(),
        home: SplashScreen(),
        );
  }
}
