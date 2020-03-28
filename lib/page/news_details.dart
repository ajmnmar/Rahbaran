import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/news_model.dart';
import 'package:rahbaran/helper/widget_helper.dart';

import 'base_state.dart';

class NewsDetails extends StatefulWidget {
  final NewsModel news;

  NewsDetails(this.news);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsDetailsState(this.news);
  }
}

class NewsDetailsState extends BaseState<NewsDetails> {
  final NewsModel news;

  NewsDetailsState(this.news);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken().then((val) {
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
              title: Text('جزئیات خبر1'),
              centerTitle: true,
              elevation: 2,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.arrow_forward), onPressed: (){
                  Navigator.of(context).pop();
                })
              ],
            ),
            drawer:mainDrawer(),
            body: newsBody(context)),
        WidgetHelper.messageSection(messageOpacity,
            MediaQuery.of(context).padding.top, message, messageVisibility, () {
              setState(() {
                messageVisibility = messageOpacity == 0 ? false : true;
              });
            })
      ],
    );
  }

  TextStyle newsTitleTextStyle =
  TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle newsBodyTextStyle = TextStyle(color: Colors.black, fontSize: 17);

  newsBody(context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height*.4,
            child:Image.network(news.messageImageAddress,fit: BoxFit.fill),
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 1,
            color: Colors.black12,
            width: MediaQuery.of(context).size.width * .8,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(news.messageTitle,style: newsTitleTextStyle,),
          ),
          new Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              child: new SingleChildScrollView(
                child: new Text(news.messageBody,style: newsBodyTextStyle,textAlign: TextAlign.justify,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

