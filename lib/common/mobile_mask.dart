class MobileMask{
  static String changeMobileMaskDirection(String mobile){
    try {
      var part1 = mobile.substring(mobile.length-3);
      var part2 = mobile.substring(0, mobile.length-3);
      return part1+part2;
    }catch(e){
      return mobile;
    }
  }
}