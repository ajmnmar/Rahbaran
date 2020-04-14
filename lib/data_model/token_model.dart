class TokenModel{
  String token;
  String refreshToken;

  TokenModel(this.token,this.refreshToken);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['token'] = token;
    map['refreshtoken'] = refreshToken;

    return map;
  }

  TokenModel.fromMapObject(Map<String, dynamic> map) {
    this.token = map['token'];
    this.refreshToken = map['refreshtoken'];
  }



}