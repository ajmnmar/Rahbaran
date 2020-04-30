import 'package:rahbaran/data_model/user_model.dart';

class RegisterStep2Argument{
  final String guid;
  final String otp;
  final UserModel userModel;

  RegisterStep2Argument(this.guid,this.otp,this.userModel);
}