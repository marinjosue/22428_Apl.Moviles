import '../models/Year.dart';

class YearController {
  bool verifyBisiesto(int year){
    return Year(year).isBisiesto();
  }

  List <int> getLast(int init){
    List<int> list = [];
    int actual = init;
    while(list.length < 10 && actual > 0){
      if (verifyBisiesto(actual)){
        list.add(actual);
      }
      actual--;
    }
    return list;
  }
}