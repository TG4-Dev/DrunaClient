import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoMono',
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoMono',
    ),
    labelSmall: TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontFamily: 'RobotoMono',
    )
  ),
);
