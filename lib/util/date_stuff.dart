import 'package:shamsi_date/shamsi_date.dart';

class DateStuff {
  static String formatRegular(DateTime date) {
    final f = date.toJalali().formatter;
    return '${f.yyyy}/${f.mm}/${f.dd}';
  }
}
