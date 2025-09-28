import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    primaryColor: const Color.fromARGB(255, 24, 176, 138),
    scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 24, 176, 138),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF212121)),
      bodyMedium: TextStyle(color: Color(0xFF616161)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 24, 176, 138),
        foregroundColor: Colors.white,
      ),
    ),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Color(0xFF212121)),
    dividerColor: const Color(0xFFBDBDBD),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    primaryColor: const Color.fromARGB(255, 24, 176, 138),
    scaffoldBackgroundColor: const Color.fromARGB(255, 62, 62, 62),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 24, 176, 138),
      foregroundColor: Colors.black,
    ),
  );
}
