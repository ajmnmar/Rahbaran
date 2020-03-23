class NationalCode{
  static bool checkNationalCode(String code){
    code=code.trim();
    if(code.length<8 || int.tryParse(code)==null) return false;
    code=code.padLeft(10,'0');
    var temp1=int.tryParse(code.substring(9));
    var temp2=0;
    for(var i=0;i<9;i++) {
      temp2 += int.parse(code.substring(i, i+1)) * (10 - i);
    }
    var temp3=temp2%11;
    return ((temp3<2&&temp1==temp3)||((temp3>=2)&&((11-temp3)==temp1)));
  }
}