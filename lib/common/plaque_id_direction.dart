class PlaqueIdDirection{
  static String changePlaqueIdDirection(String plaqueId){
    try {
      var part1 = plaqueId.substring(0,2);
      var part2 = plaqueId.substring(2,3);
      var part3 = plaqueId.substring(3,6);
      return part3+part2+part1;
    }catch(e){
      return plaqueId;
    }
  }
}