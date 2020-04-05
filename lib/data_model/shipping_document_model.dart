import 'package:rahbaran/data_model/driver_model.dart';

class ShippingDocumentModel {
  int id;
  String docTypeStr;
  String docTypeString;
  String plaqueNumber;
  int plaqueSerial;
  String issueDate;
  String calcIssueDate;
  String source;
  String destination;
  String carrierCompany;
  String forwarderCompany;
  String goodTitle;
  double goodWeight;
  String loader;
  String trackingCode;
  String sourcePostalCode;
  String destinationPostalCode;
  String nationalCode;
  int docType;
  String fullPlaqueString;
  String issueDateString;
  String issueDateStringS;
  String userMode;
  String timeRahdari;
  String cost;
  String commission;
  String serial;
  String senderNationalCode;
  String senderFullName;
  String receiverNationalCode;
  String receiverFullName;
  String timeRahdariS;
  String costS;
  String commissionS;
  String destinationZoneCode;
  String originZoneCode;
  List<DriverModel> drivers;

  ShippingDocumentModel(this.id,this.docTypeStr,this.docTypeString,this.plaqueNumber,
      this.plaqueSerial,this.issueDate,this.calcIssueDate, this.source,
      this.destination,this.carrierCompany,this.forwarderCompany,this.goodTitle,
      this.goodWeight,this.loader,this.trackingCode, this.sourcePostalCode,
      this.destinationPostalCode,this.nationalCode,this.docType,
      this.fullPlaqueString,this.issueDateString,this.issueDateStringS,
      this.userMode,this.timeRahdari,this.cost,this.commission,this.serial,
      this.senderNationalCode,this.senderFullName,this.receiverNationalCode,
      this.receiverFullName,this.timeRahdariS,this.costS,this.commissionS,
      this.destinationZoneCode,this.originZoneCode,this.drivers);

  factory ShippingDocumentModel.fromJson(dynamic json) {
    List<DriverModel> tempDrivers=List<DriverModel>();
    for(var value in json['drivers']){
      tempDrivers.add(DriverModel.fromJson(value));
    }

    return ShippingDocumentModel(
      json['id'],
      json['docTypeStr'],
      json['docTypeString'],
      json['plaqueNumber'],
      json['plaqueSerial'],
      json['issueDate'],
      json['calcIssueDate'],
      json['source'],
      json['destination'],
      json['carrierCompany'],
      json['forwarderCompany'],
      json['goodTitle'],
      json['goodWeight'],
      json['loader'],
      json['trackingCode'],
      json['sourcePostalCode'],
      json['destinationPostalCode'],
      json['nationalCode'],
      json['docType'],
      json['fullPlaqueString'],
      json['issueDateString'],
      json['issueDateStringS'],
      json['userMode'],
      json['timeRahdari'],
      json['cost'],
      json['commission'],
      json['serial'],
      json['senderNationalCode'],
      json['senderFullName'],
      json['receiverNationalCode'],
      json['receiverFullName'],
      json['timeRahdariS'],
      json['costS'],
      json['commissionS'],
      json['destinationZoneCode'],
      json['originZoneCode'],
      tempDrivers
    );
  }



}