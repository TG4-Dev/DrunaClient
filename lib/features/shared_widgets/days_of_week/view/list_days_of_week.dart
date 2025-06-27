

import 'package:flutter/material.dart';
import 'package:druna_app/features/shared_widgets/days_of_week/view_model/day.dart';

class ListDaysOfWeek extends StatefulWidget {
  final ValueChanged<Day>? onDaySelected;
  final Day? initialSelectedDay;

  const ListDaysOfWeek({
    super.key,
    this.onDaySelected,
    this.initialSelectedDay,
  });

  @override
  State<ListDaysOfWeek> createState() => _ListDaysOfWeekState();
}

class _ListDaysOfWeekState extends State<ListDaysOfWeek> {
  final List<Day> daysOfWeek = DayModel.generateDaysOfWeek(7);
    late Day selectedDay = daysOfWeek[0];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: daysOfWeek.length,
      itemBuilder: (context, index) {
        final day = daysOfWeek[index];
        final isSelected = selectedDay.date == day.date;

        return Center(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size(50, 50)
              ),
              onPressed: () {
                setState(() {
                  selectedDay = day;
                });
                widget.onDaySelected?.call(day);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${day.day}\n${day.date}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        );
      },
    );
  }
}
