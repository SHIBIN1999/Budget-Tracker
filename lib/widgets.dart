import 'package:intl/intl.dart';

String parseDate(DateTime date) {
  return DateFormat.yMMMEd().format(date);
}
