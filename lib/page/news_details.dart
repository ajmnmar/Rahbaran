import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/news_model.dart';

class NewsDetails extends StatelessWidget {
  final NewsModel news;

  NewsDetails(this.news);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جزئیات خبر'),
        centerTitle: true,
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: (){
            Navigator.of(context).pop();
          })
        ],
      ),
      body: newsBody(context),
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
