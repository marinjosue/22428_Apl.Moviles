class Year{
  final int year;

  Year(this.year);

  bool isBisiesto(){
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)){
      return true;
    }
    return false;
  }
}