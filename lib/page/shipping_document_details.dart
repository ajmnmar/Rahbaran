import 'package:flutter/material.dart';
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
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Plaque(
                    shippingDocument.plaqueSerial == null
                        ? '--'
                        : shippingDocument.plaqueSerial.toString(),
                    shippingDocument.plaqueNumber)
            ),
          )
        ],
      ),
    );
  }

  plaqueSection() {}
}
