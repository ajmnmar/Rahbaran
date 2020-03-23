import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rahbaran/data_model/news_model.dart';
import 'package:rahbaran/page/news_details.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class News extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsState();
  }
}

class NewsState extends State<News> {
  TextStyle newsTitleTextStyle =
  TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);
  TextStyle newsDateTextStyle = TextStyle(color: Colors.grey, fontSize: 16);
  TextStyle newsBodyTextStyle = TextStyle(color: Colors.black, fontSize: 16);
  TextStyle detailsButtonTextStyle =
  TextStyle(color: Color(0xff1fd3ae), fontSize: 16);

  String token;
  List<NewsModel> newsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*getToken().then((val) {
      token = val;
    });*/
    token =
        'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjMwMmRiZmE0LTJkMTUtZWExMS1hNDAxLTAwNTA1NmEwNDk4NSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIwMDUyMjQ1NTc4IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZ2l2ZW5uYW1lIjoi2YXYrdmF2YjYryDYrtix2YXZhiDYqNmK2LIiLCJleHAiOjE1ODQ4MDg1MDUsImlzcyI6InBmLWhhbWJhciIsImF1ZCI6InBmIn0.Ne56TUPD3Z1V8-8idj6WQFG2nk-pEiUFvdIqHaL-KuCmzJ3HIRWqs5-3zSCZQuQg9ckiL_dGiKfDO4lPAp-0yg';
    getNews(token).then((val) {
      setState(() {
        newsList = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('اخبار'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return newsCard(newsList[index]);
        },
        itemCount: newsList == null ? 0 : newsList.length,
      ),
    );
  }

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    if (token == null) {
      //to do
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> rout) => false);
    }
    return token;
  }

  void logout() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        (Route<dynamic> rout) => false);
  }

  getNews(String token) async {
    var url = 'https://apimy.rmto.ir/api/Hambar/Getmessages';
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        var newsJsonList = jsonResponse['data'] as List;
        List<NewsModel> newsList =
            newsJsonList.map((news) => NewsModel.fromJson(news)).toList();
        return newsList;
      } else {
        //to do
      }
    } else if (response.statusCode == 401) {
      logout();
    } else {
      //to do
    }
  }

  Widget newsCard(NewsModel news) {
    return Card(
        margin: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: Image.network(news.messageImageAddress,
                          fit: BoxFit.fill),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(news.messageTitle, style: newsTitleTextStyle),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                              'تاریخ انتشار: ${news.publishDate.day.toString().padLeft(2, '0')}-${news.publishDate.month.toString().padLeft(2, '0')}-${news.publishDate.year.toString()}',
                              style: newsDateTextStyle)
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width * .75,
                ),
                Container(
                  child: Text(
                    '${news.messageBody.substring(0, 120)}...',
                    style: newsBodyTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NewsDetails(news))
                        );
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        'بیشتر',
                        style: detailsButtonTextStyle,
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
