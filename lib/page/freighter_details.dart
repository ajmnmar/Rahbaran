import 'package:flutter/material.dart';
import 'package:rahbaran/Widget/grid_cell.dart';
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/plaque.dart';
import 'package:rahbaran/common/plaque_id_direction.dart';
import 'package:rahbaran/data_model/freighter_model.dart';
import 'package:rahbaran/theme/style_helper.dart';

import 'base_authorized_state.dart';

class FreighterDetails extends StatefulWidget {
  final FreighterModel freighter;

  FreighterDetails(this.freighter);

  @override
  FreighterDetailsState createState() => FreighterDetailsState(freighter);
}

class FreighterDetailsState extends BaseAuthorizedState<FreighterDetails> {
  final FreighterModel freighter;
  List<List> freighterFields;


  FreighterDetailsState(this.freighter) :super(1) {
    freighterFields = [
      ['شماره کارت هوشمند:', freighter.cardNumber],
      ['شماره ملی صاحب ناوگان:', freighter.nationalCode],
      ['بارگیر:', freighter.loaderType.toString()],
      ['ظرفیت:', freighter.quantity.toString()],
      ['تعداد محور:', freighter.axis.toString()],
      ['اعتبار معاینه فنی:', freighter.technicalExaminationDate],
      ['سیستم:', freighter.system],
      ['تیپ:', freighter.type],
      ['VIN:', freighter.vin],
      ['مسافت طی شده آخرین دوره:', freighter.distance],
      ['سوخت تخصیصی ماه جاری:', freighter.quota.toString()],
    ];
  }

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
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text('جزئیات ناوگان'),
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
            bottomNavigationBar: MainBottomNavigationBar(bottomNavigationSelectedIndex),
            body: freighterBody(context)),
        Message(errorBloc),
      ],
    );
  }

  freighterBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                plaqueSection(),
                freighterDetailsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  plaqueSection() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'پلاک ناوگان',
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
                  )),
              Plaque(freighter.plaqueSerial, freighter.plaqueId),
            ],
          )),
    );
  }

  freighterDetailsSection() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'جزئیات ناوگان',
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
                )),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: freighterFields.length,
              itemBuilder: (BuildContext context, int index) {
                return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        index % 2 == 0
                            ? PrimaryGridCell(freighterFields[index][0])
                            : SecondaryGridCell(freighterFields[index][0]),
                        index % 2 == 0
                            ? PrimaryGridCell(freighterFields[index][1])
                            : SecondaryGridCell(freighterFields[index][1]),
                      ],
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
