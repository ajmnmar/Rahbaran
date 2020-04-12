class SettingModel{
  String token;
  String refreshToken;

  SettingModel(this.token,this.refreshToken);

  factory SettingModel.fromJson(dynamic json) {
    return SettingModel(
        json['token'],
        json['refreshtoken'],
    );
  }
}