import 'package:flutter/material.dart';
import 'package:rahbaran/Widget/grid_cell.dart';
import 'package:rahbaran/Widget/main_bottom_navigation_bar.dart';
import 'package:rahbaran/Widget/message.dart';
import 'package:rahbaran/Widget/plaque.dart';
import 'package:rahbaran/Widget/primary_drawer.dart';
import 'package:rahbaran/data_model/shipping_document_model.dart';
import 'package:rahbaran/page/argument/shipping_document_details_argument.dart';
import 'package:rahbaran/page/base_authorized_state.dart';

class ShippingDocumentDetails extends StatefulWidget {
  static const routeName = '/ShippingDocumentDetails';

  @override
  ShippingDocumentDetailsState createState() => ShippingDocumentDetailsState();
}

class ShippingDocumentDetailsState
    extends BaseAuthorizedState<ShippingDocumentDetails> {
  ShippingDocumentDetailsArgument shippingDocumentDetailsArgument;
  List<List> shippingDocumentFields;

  ShippingDocumentDetailsState() : super(2);

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
    shippingDocumentDetailsArgument = ModalRoute.of(context).settings.arguments;
    if(shippingDocumentDetailsArgument.shippingDocument.docTypeString.toLowerCase()=='passenger') {
      shippingDocumentFields = [
        [
          'تاریخ صدور:',
          shippingDocumentDetailsArgument.shippingDocument.issueDate
        ],
        ['شهر مبدا:', shippingDocumentDetailsArgument.shippingDocument.source],
        [
          'کدپستی مبدا:',
          shippingDocumentDetailsArgument.shippingDocument.sourcePostalCode
        ],
        [
          'شهر مقصد:',
          shippingDocumentDetailsArgument.shippingDocument.destination
        ],
        [
          'کدپستی مقصد:',
          shippingDocumentDetailsArgument.shippingDocument.destinationPostalCode
        ],
        [
          'شرکت فرابر:',
          shippingDocumentDetailsArgument.shippingDocument.forwarderCompany
        ],
        [
          'شرکت حمل و نقل:',
          shippingDocumentDetailsArgument.shippingDocument.carrierCompany
        ],
        [
          'کدرهگیری:',
          shippingDocumentDetailsArgument.shippingDocument.trackingCode
        ],
        [
          'زمان ثبت در راهداری:',
          shippingDocumentDetailsArgument.shippingDocument.timeRahdariS
        ],
        ['تعداد مسافر:', shippingDocumentDetailsArgument.shippingDocument.goodWeight.toInt()],
        ['کرایه:', shippingDocumentDetailsArgument.shippingDocument.costS],
        [
          'دریافتی از راننده:',
          shippingDocumentDetailsArgument.shippingDocument.commissionS
        ],
        [
          'شماره صورت وضعیت:',
          shippingDocumentDetailsArgument.shippingDocument.serial
        ],
        ['نوع وسیله:', shippingDocumentDetailsArgument.shippingDocument.loader],
      ];
    }else{
      shippingDocumentFields = [
        [
          'تاریخ صدور:',
          shippingDocumentDetailsArgument.shippingDocument.issueDate
        ],
        ['شهر مبدا:', shippingDocumentDetailsArgument.shippingDocument.source],
        [
          'کدپستی مبدا:',
          shippingDocumentDetailsArgument.shippingDocument.sourcePostalCode
        ],
        [
          'شهر مقصد:',
          shippingDocumentDetailsArgument.shippingDocument.destination
        ],
        [
          'کدپستی مقصد:',
          shippingDocumentDetailsArgument.shippingDocument.destinationPostalCode
        ],
        [
          'شرکت فرابر:',
          shippingDocumentDetailsArgument.shippingDocument.forwarderCompany
        ],
        [
          'شرکت حمل و نقل:',
          shippingDocumentDetailsArgument.shippingDocument.carrierCompany
        ],
        [
          'کدرهگیری:',
          shippingDocumentDetailsArgument.shippingDocument.trackingCode
        ],
        [
          'زمان ثبت در راهداری:',
          shippingDocumentDetailsArgument.shippingDocument.timeRahdariS
        ],
        ['شرح کالا:', shippingDocumentDetailsArgument.shippingDocument.goodTitle],
        ['وزن:', shippingDocumentDetailsArgument.shippingDocument.goodWeight],
        ['کرایه:', shippingDocumentDetailsArgument.shippingDocument.costS],
        [
          'دریافتی از راننده:',
          shippingDocumentDetailsArgument.shippingDocument.commissionS
        ],
        [
          'سریال بارنامه:',
          shippingDocumentDetailsArgument.shippingDocument.serial
        ],
        ['بارگیر:', shippingDocumentDetailsArgument.shippingDocument.loader],
        [
          'نام فرستنده کالا:',
          shippingDocumentDetailsArgument.shippingDocument.senderFullName
        ],
        [
          'نام گیرنده کالا:',
          shippingDocumentDetailsArgument.shippingDocument.receiverFullName
        ],
      ];
    }
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text('جزئیات سند حمل',
                  style: Theme.of(context).textTheme.title),
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
            drawer: PrimaryDrawer(
              currentUser: currentUser,
              logout: logout,
            ),
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
                (shippingDocumentDetailsArgument.shippingDocument.drivers ==
                            null ||
                        shippingDocumentDetailsArgument
                                .shippingDocument.drivers.length ==
                            0)
                    ? Container()
                    : driverSection()
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
                    style: Theme.of(context).textTheme.headline,
                  )),
              Plaque(
                  shippingDocumentDetailsArgument.shippingDocument.plaqueSerial == null
                      ? '--'
                      : shippingDocumentDetailsArgument.shippingDocument.plaqueSerial.toString(),
                  shippingDocumentDetailsArgument.shippingDocument.plaqueNumber),
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
                  style: Theme.of(context).textTheme.headline,
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
                  style: Theme.of(context).textTheme.headline,
                )),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: shippingDocumentDetailsArgument.shippingDocument.drivers.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        PrimaryGridCell('نام:'),
                        PrimaryGridCell(shippingDocumentDetailsArgument.shippingDocument.drivers[index].name)
                      ],
                    )),
                    IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SecondaryGridCell('نام خانوادگی:'),
                        SecondaryGridCell(
                            shippingDocumentDetailsArgument.shippingDocument.drivers[index].lastname)
                      ],
                    )),
                    IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        PrimaryGridCell('شماره ملی:'),
                        PrimaryGridCell(
                            shippingDocumentDetailsArgument.shippingDocument.drivers[index].nationalCode)
                      ],
                    )),
                    IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SecondaryGridCell('نام لاتین:'),
                        SecondaryGridCell(
                            shippingDocumentDetailsArgument.shippingDocument.drivers[index].nameEn)
                      ],
                    )),
                    IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        PrimaryGridCell('نام خانوادگی لاتین:'),
                        PrimaryGridCell(
                            shippingDocumentDetailsArgument.shippingDocument.drivers[index].lastnameEn)
                      ],
                    )),
                    Container(
                      height: index == shippingDocumentDetailsArgument.shippingDocument.drivers.length - 1
                          ? 0
                          : 15, //is last
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
