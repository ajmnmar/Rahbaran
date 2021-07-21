import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahbaran/Widget/grid_cell.dart';
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/plaque.dart';
import 'package:rahbaran/bloc/error_bloc.dart';
import 'package:rahbaran/bloc/loading_bloc.dart';
import 'package:rahbaran/common/plaque_id_direction.dart';
import 'package:rahbaran/data_model/havale_model.dart';
import 'package:rahbaran/page/argument/freighter_details_argument.dart';
import 'package:rahbaran/page/freighter_details.dart';
import 'package:rahbaran/theme/style_helper.dart';
import 'package:rahbaran/page/base_state.dart';
import 'dart:convert' as convert;

import 'base_authorized_state.dart';

class Havale extends StatefulWidget {
  static const routeName = '/Havale';

  @override
  HavaleState createState() => HavaleState();
}

class HavaleState extends BaseAuthorizedState<Havale> {
  //variables
  List<HavaleModel> havaleList;
  LoadingBloc loadingBloc = new LoadingBloc();

  @override
  void initState() {
    super.initState();

    loadingBloc.add(LoadingEvent.show);
    getToken().then((val) {
      getHavale().then((list) {
        loadingBloc.add(LoadingEvent.hide);
        setState(() {
          havaleList = list;
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
            title: Text('لیست حواله',style: Theme.of(context).textTheme.title),
            centerTitle: true,
            elevation: 2,
          ),
          drawer: PrimaryDrawer(currentUser: currentUser,logout: logout,),
          body: BlocBuilder(
              bloc: loadingBloc,
              builder: (context, LoadingState state) {
                return havaleListBody(state);
              }),
          bottomNavigationBar: MainBottomNavigationBar(bottomNavigationSelectedIndex),
        ),
        Message(errorBloc),
      ],
    );
  }

  havaleListBody(LoadingState state) {
    if (state.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
              new AlwaysStoppedAnimation<Color>(StyleHelper.mainColor)));
    } else {
      if (havaleList == null || havaleList.length == 0) {
        return Center(
          child: Text(
            'حواله ای برای شما یافت نشد!',
            style: Theme.of(context).textTheme.display2,
          ),
        );
      } else {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return havaleCard(havaleList[index]);
          },
          itemCount: havaleList.length,
        );
      }
    }
  }

  havaleCard(HavaleModel havale) {
    return Card(
        margin: EdgeInsets.all(10),
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3))),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: StyleHelper.mainColor, width: 5))),
            child: Column(
              children: <Widget>[
                Plaque(havale.plaqueSerial, havale.plaqueId),
                Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  endIndent: MediaQuery.of(context).size.width * .08,
                  indent: MediaQuery.of(context).size.width * .08,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TertiaryGridCell('تاریخ صدور:'),
                      TertiaryGridCell(havale.issuePersianDate),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TertiaryGridCell('وضعیت:'),
                      TertiaryGridCell(havale.state),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TertiaryGridCell('شرکت حمل و نقل:'),
                      TertiaryGridCell(havale.companyCarrier),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TertiaryGridCell('شهر مبدا:'),
                      TertiaryGridCell(havale.source),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TertiaryGridCell('شهر مقصد:'),
                      TertiaryGridCell(havale.destination),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  getHavale() async {
    var url = 'https://apimy.rmto.ir/api/Hambar/getbill';
    var response = await getApiData(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response != null) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message']['code'] == 0) {
        var havaleJsonList = jsonResponse['data'] as List;
        return havaleJsonList
            .map((havale) => HavaleModel.fromJson(havale))
            .toList();
      } else {
        errorBloc.add(ShowErrorEvent('خطا در ارتباط با سرور'));
      }
    }
  }
}

