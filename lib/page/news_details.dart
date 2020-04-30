import 'package:flutter/material.dart';
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/data_model/news_model.dart';
import 'package:rahbaran/page/argument/news_details_argument.dart';
import 'base_authorized_state.dart';
import 'base_state.dart';

class NewsDetails extends StatefulWidget {
  static const routeName = '/NewsDetails';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsDetailsState();
  }
}

class NewsDetailsState extends BaseAuthorizedState<NewsDetails> {
  //variable
  NewsDetailsArgument newsDetailsArgument;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken().then((val) {
      initCurrentUser().then((val) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    newsDetailsArgument = ModalRoute.of(context).settings.arguments;

    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text('جزئیات خبر',style: Theme.of(context).textTheme.title),
              centerTitle: true,
              elevation: 2,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
            drawer: PrimaryDrawer(currentUser: currentUser,logout: logout,),
            bottomNavigationBar:
                MainBottomNavigationBar(bottomNavigationSelectedIndex),
            body: newsBody(context)),
        Message(errorBloc),
      ],
    );
  }

  newsBody(context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * .35,
            child: Image.network(newsDetailsArgument.news.messageImageAddress, fit: BoxFit.fill),
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 1,
            color: Colors.black12,
            width: MediaQuery.of(context).size.width * .8,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              newsDetailsArgument.news.messageTitle,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: new SingleChildScrollView(
                child: new Text(
                  newsDetailsArgument.news.messageBody,
                  style: Theme.of(context).textTheme.body2,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
