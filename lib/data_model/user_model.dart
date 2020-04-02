import 'package:rahbaran/data_model/user_mode.dart';
import 'dart:convert' as convert;

class UserModel {
  String id;
  String firstName;
  String lastName;
  String fullName;
  String companyName;
  String nationalCode;
  String mobile;
  String email;
  String userImageAddress;
  int userModeId;
  UserMode userMode;

  UserModel(
      this.id,
      this.firstName,
      this.lastName,
      this.fullName,
      this.companyName,
      this.nationalCode,
      this.mobile,
      this.email,
      this.userImageAddress,
      this.userModeId,
      this.userMode);

  userModeName(){
    if(userMode == null)
      return '';

    switch(userMode) {
      case UserMode.owner:
        return 'صاحب ناوگان';
      case UserMode.driver:
        return 'راننده';
    }
  }

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
        json['id'].toString(),
        json['firstname'],
        json['lastname'],
        json['fullName'],
        json['companyName'],
        json['nationalCode'],
        json['mobile'],
        json['email'],
        json['userImageAddress'],
        json['userModeId'],
        UserMode.values[json['userModeId']]
    );
  }

  toJson() {
    return convert.json.encode({
      'id':id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'companyName': companyName,
      'nationalCode': nationalCode,
      'mobile': mobile,
      'email': email,
      'userImageAddress':userImageAddress,
      'userModeId':userModeId
    });
  }
}
