import 'package:druna_app/features/shared_widgets/days_of_week/view/list_days_of_week.dart';
import 'package:druna_app/features/shared_widgets/days_of_week/view_model/day.dart';
import 'package:flutter/material.dart';

class OneWeekScreen extends StatefulWidget {
  const OneWeekScreen({super.key});

  @override
  State<OneWeekScreen> createState() => _OneWeekScreenState();
}

class _OneWeekScreenState extends State<OneWeekScreen> {
  final List<Day> daysOfWeek = DayModel.generateDaysOfWeek(7);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 70,
            color: Colors.amberAccent,
            child: ListDaysOfWeek(),
          ),
        ],
      ),
    );
  }
}
