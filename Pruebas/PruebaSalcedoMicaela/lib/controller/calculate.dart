// 📁 controller/calculate.dart
class Calculate {
  static List<double> exponentialPayments(int months, double initial) {
    List<double> payments = [];
    for (int i = 0; i < months; i++) {
      payments.add(initial * (1 << i));
    }
    return payments;
  }
}
