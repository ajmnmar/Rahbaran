import 'package:flutter/material.dart';
import 'package:rahbaran/data_model/freighter_model.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/base_state.dart';

class Freighter extends StatefulWidget {
  @override
  FreighterState createState() => FreighterState();
}

class FreighterState extends BaseState<Freighter> {
  //variables
  List<FreighterModel> freighterList;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = true;
    getToken().then((val) {
      getFreighter().then((list) {
        setState(() {
          freighterList = list;
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
              title: Text('لیست ناوگان'),
              centerTitle: true,
              elevation: 2,
            ),
            drawer:mainDrawer(),
            body: freighterListBody()),
        WidgetHelper.messageSection(messageOpacity,
            MediaQuery.of(context).padding.top, message, messageVisibility, () {
              setState(() {
                messageVisibility = messageOpacity == 0 ? false : true;
              });
            })
      ],
    );
  }

  freighterListBody() {

  }

  getFreighter() {}
}
