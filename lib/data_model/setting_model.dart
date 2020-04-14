class SettingModel{
  String token;
  String refreshToken;

  SettingModel(this.token,this.refreshToken);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['token'] = token;
    map['refreshtoken'] = refreshToken;

    return map;
  }

  SettingModel.fromMapObject(Map<String, dynamic> map) {
    this.token = map['token'];
    this.refreshToken = map['refreshtoken'];
  }



}