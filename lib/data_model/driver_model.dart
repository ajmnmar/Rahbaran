class DriverModel{
  String nationalCode;
  String name;
  String lastname;
  String nameEn;
  String lastnameEn;

  DriverModel(this.nationalCode,this.name,this.lastname,this.nameEn,
      this.lastnameEn);

  factory DriverModel.fromJson(dynamic json) {
    return DriverModel(
      json['nationalCode'],
      json['name'],
      json['lastname'],
      json['nameEn'],
      json['lastnameEn']
    );
  }
}