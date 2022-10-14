import 'package:flutter/material.dart';

class CustomTheme {
  static const String font = 'Pokemon';
  static const DividerThemeData divider = DividerThemeData(thickness: 1);
  static const FABTheme = FloatingActionButtonThemeData(
    backgroundColor: Colors.amber,
  );
  static Color colorString(String strColor) {
    switch (strColor) {
      case 'black':
        return Colors.black.withOpacity(0.5);
      case 'blue':
        return Colors.blue.withOpacity(0.5);
      case 'brown':
        return Colors.brown.withOpacity(0.5);
      case 'gray':
        return Colors.grey.withOpacity(0.5);
      case 'green':
        return Colors.green.withOpacity(0.5);
      case 'pink':
        return Colors.pink.withOpacity(0.5);
      case 'purple':
        return Colors.purple.withOpacity(0.5);
      case 'red':
        return Colors.red.withOpacity(0.5);
      case 'white':
        return Colors.grey.withOpacity(0.5);
      case 'yellow':
        return Colors.yellow.withOpacity(0.5);
      default:
        return Colors.blueGrey.withOpacity(0.5);
    }
  }

  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade100,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: font,
        fontSize: 25,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FABTheme.copyWith(foregroundColor: Colors.white),
    colorScheme: const ColorScheme.light(
      primary: Colors.amber,
      onPrimary: Colors.white,
    ),
    dividerTheme: divider,
  );

  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: font,
        fontSize: 25,
        color: Colors.amber,
      ),
    ),
    floatingActionButtonTheme: FABTheme.copyWith(foregroundColor: Colors.black),
    colorScheme: const ColorScheme.dark(
      surface: Colors.black,
      onSurface: Colors.amber,
      primary: Colors.amber,
    ),
    dividerTheme: divider,
  );
}
