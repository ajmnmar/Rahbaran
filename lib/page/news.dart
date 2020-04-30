import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/data_model/news_model.dart';
import 'package:rahbaran/page/argument/news_details_argument.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:rahbaran/page/news_details.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_authorized_state.dart';
import 'base_state.dart';
import 'freighter.dart';
import 'login.dart';

class News extends StatefulWidget {
  static const routeName = '/News';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsState();
  }
}

class NewsState extends BaseAuthorizedState<News> {
  //style
  TextStyle newsDateTextStyle = TextStyle(color: Colors.grey, fontSize: 16);

  //variable
  List<NewsModel> newsList;
  LoadingBloc loadingBloc = new LoadingBloc();

  NewsState():super(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadingBloc.add(LoadingEvent.show);
    getToken().then((val) {
      getNews().then((list) {
        loadingBloc.add(LoadingEvent.hide);
        setState(() {
          newsList = list;
        });
      });
      initCurrentUser().then((val) {
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
              title: Text('اخبار',style: Theme.of(context).textTheme.title),
              centerTitle: true,
              elevation: 2,
            ),
          drawer: PrimaryDrawer(currentUser: currentUser,logout: logout,),
            body: BlocBuilder(
                bloc: loadingBloc,
                builder: (context, LoadingState state) {
                  return newsListBody(state);
                }),
          bottomNavigationBar: MainBottomNavigationBar(bottomNavigationSelectedIndex),
        ),
        Message(errorBloc),
      ],
    );
  }

  Widget newsListBody(LoadingState state) {
    if (state.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(StyleHelper.mainColor)));
    } else {
      if (newsList == null || newsList.length == 0) {
        return Center(
          child: Text(
            'خبری برای نمایش وجود ندارد!',
            style: Theme.of(context).textTheme.display2,
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
                      height: 65,
                      width: 65,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Image.network(news.messageImageAddress,
                          fit: BoxFit.contain),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(news.messageTitle, style: Theme.of(context).textTheme.headline),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                              //'تاریخ انتشار: ${news.publishDate.day.toString().padLeft(2, '0')}-${news.publishDate.month.toString().padLeft(2, '0')}-${news.publishDate.year.toString()}',
                              'تاریخ انتشار: ${news.shamsiPublishDate}',
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
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(NewsDetails.routeName,
                          arguments: NewsDetailsArgument(news));
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        'بیشتر',
                        style: StyleHelper.detailsButtonTextStyle,
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
        errorBloc.add(ShowErrorEvent('خطا در ارتباط با سرور'));
      }
    }
  }
}
