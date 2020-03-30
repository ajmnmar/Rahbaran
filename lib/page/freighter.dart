import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/common/plaque_id_direction.dart';
import 'package:rahbaran/data_model/freighter_model.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:rahbaran/helper/widget_helper.dart';
import 'package:rahbaran/page/base_state.dart';
import 'dart:convert' as convert;

class Freighter extends StatefulWidget {
  @override
  FreighterState createState() => FreighterState();
}

class FreighterState extends BaseState<Freighter> {
  //style
  TextStyle plateTextStyle = TextStyle(fontSize: 18);

  //variables
  List<FreighterModel> freighterList;
  LoadingBloc loadingBloc = new LoadingBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadingBloc.add(LoadingEvent.show);
    getToken().then((val) {
      getFreighter().then((list) {
        setState(() {
          freighterList = list;
          loadingBloc.add(LoadingEvent.hide);
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
          drawer: mainDrawer(),
          body: BlocBuilder(
              bloc: loadingBloc,
              builder: (context, LoadingState state) {
                return freighterListBody(state);
              }),
        ),
        messageSection(errorBloc),
      ],
    );
  }

  freighterListBody(LoadingState state) {
    if (state.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(StyleHelper.mainColor)));
    } else {
      if (freighterList == null || freighterList.length == 0) {
        return Center(
          child: Text(
            'ناوگانی برای شما یافت نشد!',
            style: Theme.of(context).textTheme.subhead,
          ),
        );
      } else {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return freighterCard(freighterList[index]);
          },
          itemCount: freighterList.length,
        );
      }
    }
  }

  freighterCard(FreighterModel freighter) {
    return Card(
        margin: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                    height: 45,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset('assets/images/plate.png').image,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, right: 10),
                          child: Text(
                            freighter.plaqueSerial,
                            style: plateTextStyle,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            PlaqueIdDirection.changePlaqueIdDirection(
                                freighter.plaqueId),
                            style: plateTextStyle,
                          ),
                        ))
                      ],
                    )),
                Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  endIndent: MediaQuery.of(context).size.width * .08,
                  indent: MediaQuery.of(context).size.width * .08,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              color: StyleHelper.mainColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 5),
                              margin: EdgeInsets.all(2),
                              child: Text('شماره کارت هوشمند:')),
                        ),
                        Expanded(
                            child: Container(
                                color: StyleHelper.mainColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 5),
                                margin: EdgeInsets.all(2),
                                child: Text(freighter.cardNumber)))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              color: Colors.black12,
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 5),
                              margin: EdgeInsets.all(2),
                              child: Text('اعتبار معاینه فنی:')),
                        ),
                        Expanded(
                            child: Container(
                                color: Colors.black12,
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 5),
                                margin: EdgeInsets.all(2),
                                child:
                                    Text(freighter.technicalExaminationDate)))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              color: StyleHelper.mainColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 5),
                              margin: EdgeInsets.all(2),
                              child: Text('بارگیر:')),
                        ),
                        Expanded(
                            child: Container(
                                color: StyleHelper.mainColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 5),
                                margin: EdgeInsets.all(2),
                                child: Text(freighter.loaderType.toString())))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  getFreighter() async {
    var url = 'https://apimy.rmto.ir/api/Hambar/getfreighter';
    var response = await getApiData(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response != null) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        var freighterJsonList = jsonResponse['data'] as List;
        return freighterJsonList
            .map((freighter) => FreighterModel.fromJson(freighter))
            .toList();
      } else {
        errorBloc.add(ShowErrorEvent('خطا در ارتباط با سرور'));
      }
    }
  }
}
