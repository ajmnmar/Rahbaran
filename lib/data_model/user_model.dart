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
      {this.id,
      this.firstName,
      this.lastName,
      this.fullName,
      this.companyName,
      this.nationalCode,
      this.mobile,
      this.email,
      this.userImageAddress,
      this.userModeId,
      this.userMode});

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
        id:json['id'].toString(),
        firstName:json['firstname'],
        lastName:json['lastname'],
        fullName:json['fullName'],
        companyName:json['companyName'],
        nationalCode:json['nationalCode'],
        mobile:json['mobile'],
        email:json['email'],
        userImageAddress:json['userImageAddress'],
        userModeId:json['userModeId'],
        userMode:UserMode.values[json['userModeId']]
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

  UserModel.clone(UserModel user):this(id: user.id,
      firstName:user.firstName,
      lastName:user.lastName,
      fullName:user.fullName,
      companyName:user.companyName,
      nationalCode:user.nationalCode,
      mobile:user.mobile,
      email:user.email,
      userImageAddress:user.userImageAddress,
      userModeId:user.userModeId,
      userMode: user.userMode);
}
