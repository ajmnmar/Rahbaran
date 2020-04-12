import 'package:flutter/material.dart';
import 'package:rahbaran/Widget/grid_cell.dart';
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/plaque.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/data_model/shipping_document_model.dart';
import 'package:rahbaran/page/base_authorized_state.dart';

class ShippingDocumentDetails extends StatefulWidget {
  final ShippingDocumentModel shippingDocument;

  ShippingDocumentDetails(this.shippingDocument);

  @override
  ShippingDocumentDetailsState createState() =>
      ShippingDocumentDetailsState(this.shippingDocument);
}

class ShippingDocumentDetailsState
    extends BaseAuthorizedState<ShippingDocumentDetails> {
  final ShippingDocumentModel shippingDocument;
  List<List> shippingDocumentFields;

  ShippingDocumentDetailsState(this.shippingDocument) : super(2) {
    shippingDocumentFields = [
      ['تاریخ صدور:', shippingDocument.issueDate],
      ['شهر مبدا:', shippingDocument.source],
      ['کدپستی مبدا:', shippingDocument.sourcePostalCode],
      ['شهر مقصد:', shippingDocument.destination],
      ['کدپستی مقصد:', shippingDocument.destinationPostalCode],
      ['شرکت فرابر:', shippingDocument.forwarderCompany],
      ['شرکت حمل و نقل:', shippingDocument.carrierCompany],
      ['کدرهگیری:', shippingDocument.trackingCode],
      ['زمان ثبت در راهداری:', shippingDocument.timeRahdariS],
      ['شرح کالا:', shippingDocument.goodTitle],
      ['وزن:', shippingDocument.goodWeight],
      ['کرایه:', shippingDocument.costS],
      ['دریافتی از راننده:', shippingDocument.commissionS],
      ['سریال بارنامه:', shippingDocument.serial],
      ['بارگیر:', shippingDocument.loader],
      ['نام فرستنده کالا:', shippingDocument.senderFullName],
      ['نام گیرنده کالا:', shippingDocument.receiverFullName],
    ];
  }

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
              title: Text('جزئیات سند حمل'),
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
            drawer: PrimaryDrawer(currentUser),
            bottomNavigationBar:
            MainBottomNavigationBar(bottomNavigationSelectedIndex),
            body: shippingDocumentBody(context)),
        Message(errorBloc),
      ],
    );
  }

  shippingDocumentBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                plaqueSection(),
                shippingDocumentDetailsSection(),
                (shippingDocument.drivers==null||shippingDocument.drivers.length==0)?Container():driverSection()
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
              Plaque(
                  shippingDocument.plaqueSerial == null
                      ? '--'
                      : shippingDocument.plaqueSerial.toString(),
                  shippingDocument.plaqueNumber),
            ],
          )),
    );
  }

  shippingDocumentDetailsSection() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'جزئیات سندحمل',
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
                )),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: shippingDocumentFields.length,
              itemBuilder: (BuildContext context, int index) {
                return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        index % 2 == 0
                            ? PrimaryGridCell(shippingDocumentFields[index][0])
                            : SecondaryGridCell(shippingDocumentFields[index][0]),
                        index % 2 == 0
                            ? PrimaryGridCell(shippingDocumentFields[index][1])
                            : SecondaryGridCell(shippingDocumentFields[index][1]),
                      ],
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  driverSection() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'رانندگان',
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
                )),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: shippingDocument.drivers.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            PrimaryGridCell('نام:'),
                            PrimaryGridCell(shippingDocument.drivers[index].name)
                          ],
                        )),
                    IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SecondaryGridCell('نام خانوادگی:'),
                            SecondaryGridCell(shippingDocument.drivers[index].lastname)
                          ],
                        )),
                    IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            PrimaryGridCell('شماره ملی:'),
                            PrimaryGridCell(shippingDocument.drivers[index].nationalCode)
                          ],
                        )),
                    IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SecondaryGridCell('نام لاتین:'),
                            SecondaryGridCell(shippingDocument.drivers[index].nameEn)
                          ],
                        )),
                    IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            PrimaryGridCell('نام خانوادگی لاتین:'),
                            PrimaryGridCell(shippingDocument.drivers[index].lastnameEn)
                          ],
                        )),
                    Container(
                      height: index==shippingDocument.drivers.length-1?0:15,//is last
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
