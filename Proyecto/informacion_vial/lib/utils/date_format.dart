import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatTime(DateTime date) {
  return DateFormat('HH:mm').format(date);
}
