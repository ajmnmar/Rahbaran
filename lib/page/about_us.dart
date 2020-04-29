import 'package:flutter/material.dart';
import 'package:rahbaran/Widget/logo_header.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/page/base_authorized_state.dart';
import 'dart:convert' as convert;

class AboutUs extends StatefulWidget {
  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends BaseAuthorizedState<AboutUs> {
  //variable
  String aboutUsContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAboutUs().then((val) {
      setState(() {
        aboutUsContent=val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('درباره ما', style: Theme.of(context).textTheme.title),
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
            contentSection(context)
          ],
        ),
      ),
    );
  }

  contentSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: new Text(
        aboutUsContent,
        style: Theme.of(context).textTheme.body1,
        textAlign: TextAlign.justify,
      ),
    );
  }

  getAboutUs() async{
    var url = 'https://apimy.rmto.ir/api/Hambar/getsettingbyclient';
    var response = await getApiData(url);

    if (response != null) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        return jsonResponse['data']['aboutUs'];
      } else {
        errorBloc.add(ShowErrorEvent('خطا در ارتباط با سرور'));
      }
    }
  }
}
