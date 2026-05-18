import 'package:intl/intl.dart';

class DateHelper {
  static String toYmd(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  static String toDisplay(DateTime date) => DateFormat('dd MMM yyyy').format(date);
  static String monthKey(DateTime date) => DateFormat('yyyy-MM').format(date);
}
