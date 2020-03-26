import 'package:flutter/material.dart';
import 'package:rahbaran/page/Test.dart';
import 'package:rahbaran/page/forget_password.dart';
import 'package:rahbaran/page/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rahbaran/page/news.dart';
import 'package:rahbaran/page/news_details.dart';
import 'package:rahbaran/page/pre_forget_password.dart';
import 'package:rahbaran/page/register_step2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'BYekan',
        primaryColor: Color(0xff1fd3ae)
      ),
      home: RegisterStep2('12-12','12'),
    );
  }
}



