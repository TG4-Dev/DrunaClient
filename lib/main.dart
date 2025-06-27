import 'package:druna_app/features/one_day/one_day.dart';
import 'package:druna_app/features/one_week/view/view.dart';
import 'package:druna_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ru_RU', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkTheme,
      routes: {
        '/day': (context) => OneDayScreen(),
        '/': (context) => OneWeekScreen(),  //открывается по дефолту
        },
    );
  }
}
