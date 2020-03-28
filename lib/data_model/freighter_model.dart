class FreighterModel{
  int id;
  String nationalCode;
  String plaqueId;
  String plaqueSerial;
  int loaderType;
  String cardNumber;
  String technicalExaminationDate;
  String system;
  String type;
  int axis;
  double quantity;
  int status;
  int technicalExaminationStatus;
  int quota;
  String causedActivation;
  String vin;
  String distance;

  FreighterModel(this.id,this.nationalCode,this.plaqueId,this.plaqueSerial,
      this.loaderType,this.cardNumber,this.technicalExaminationDate,
      this.system,this.type,this.axis,this.quantity,this.status,
      this.technicalExaminationStatus,this.quota,this.causedActivation,
      this.vin,this.distance);

  factory FreighterModel.fromJson(dynamic json) {
    return FreighterModel(
        json['id'],
        json['nationalCode'],
        json['plaqueId'],
        json['plaqueSerial'],
        json['loaderType'],
        json['cardNumber'],
        json['technicalExaminationDate'],
        json['system'],
        json['type'],
        json['axis'],
        json['quantity'],
        json['status'],
        json['technicalExaminationStatus'],
        json['quota'],
        json['causedActivation'],
        json['vin'],
        json['distance'],
    );
  }
}