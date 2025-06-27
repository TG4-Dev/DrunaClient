import 'package:intl/intl.dart';

class Day {
  final String day;
  final int date;

  Day({required this.day, required this.date});
}

class DayModel {
  static List<Day> generateDaysOfWeek(int daysCount) {
    final now = DateTime.now();
    final dayNameFormat = DateFormat('E', 'ru_RU');
    final dateFormat = DateFormat('d', 'ru_RU');

    return List.generate(daysCount, (index) {
      final date = now.add(Duration(days: index));
      return Day(
        day: dayNameFormat.format(date),
        date: int.parse(dateFormat.format(date)),
      );
    });
  }
}
