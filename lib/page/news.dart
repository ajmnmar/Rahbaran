import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rahbaran/data_model/news_model.dart';
import 'package:rahbaran/helper/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/news_details.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_state.dart';
import 'login.dart';

class News extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsState();
  }
}

class NewsState extends BaseState<News> {
  TextStyle newsTitleTextStyle =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);
  TextStyle newsDateTextStyle = TextStyle(color: Colors.grey, fontSize: 16);
  TextStyle newsBodyTextStyle = TextStyle(color: Colors.black, fontSize: 16);
  TextStyle detailsButtonTextStyle =
      TextStyle(color: StyleHelper.mainColor, fontSize: 16);

  List<NewsModel> newsList;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = true;
    getToken().then((val) {
      getNews().then((list) {
        setState(() {
          newsList = list;
          isLoading = false;
        });
      });
      getCurrentUser().then((val) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text('اخبار'),
              centerTitle: true,
              elevation: 2,
            ),
            drawer:mainDrawer(),
            body: newsListBody()),
        WidgetHelper.messageSection(messageOpacity,
            MediaQuery.of(context).padding.top, message, messageVisibility, () {
          setState(() {
            messageVisibility = messageOpacity == 0 ? false : true;
          });
        })
      ],
    );
  }

  Widget newsListBody() {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(StyleHelper.mainColor)));
    } else {
      if (newsList == null || newsList.length == 0) {
        return Center(
          child: Text(
            'خبری برای نمایش وجود ندارد!',
            style: StyleHelper.emptyTextStyle,
          ),
        );
      } else {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return newsCard(newsList[index]);
          },
          itemCount: newsList.length,
        );
      }
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
                Divider(
                  color: Colors.black12,
                  height: 10,
                  thickness: 1,
                  endIndent: MediaQuery.of(context).size.width * .08,
                  indent: MediaQuery.of(context).size.width * .08,
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NewsDetails(news)));
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

  getNews() async {
    var url = 'https://apimy.rmto.ir/api/Hambar/Getmessages';
    var response = await getApiData(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response != null) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        var newsJsonList = jsonResponse['data'] as List;
        List<NewsModel> newsList =
            newsJsonList.map((news) => NewsModel.fromJson(news)).toList();
        return newsList;
      } else {
        showMessage('خطا در ارتباط با سرور');
      }
    }
  }
}
