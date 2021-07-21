class HavaleModel{
  int id;
  String freighterOwnerNationalCode;
  String driverNationalCode;
  String state;
  String companyCarrier;
  String source;
  String destination;
  String issueDate;
  String issuePersianDate;
  String plaqueId;
  String plaqueSerial;





  HavaleModel(this.id,this.freighterOwnerNationalCode,this.driverNationalCode,
      this.state,this.companyCarrier,this.source,this.destination,
      this.issueDate,this.issuePersianDate, this.plaqueId,this.plaqueSerial);

  factory HavaleModel.fromJson(dynamic json) {
    return HavaleModel(
      json['id'],
      json['freighterOwnerNationalCode'],
      json['driverNationalCode'],
      json['state'],
      json['companyCarrier'],
      json['source'],
      json['destination'],
      json['issueDate'],
      json['issuePersianDate'],
      json['plaqueId'].toString(),
      json['plaqueSerial']
    );
  }
}