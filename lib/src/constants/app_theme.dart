import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF042940),
      onPrimary: Colors.white,
      secondary: Color(0xFF376AF6),
      onSecondary: Colors.white,
      tertiary: Color(0xFF8BBF56),
      onTertiary: Color.fromARGB(255, 98, 98, 98),
      surface: Color(0xFFF2F2F2),
      onSurface: Color(0xFF042940),
      error: Color(0xFFB00020),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF2F2F2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF042940),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF042940)),
      bodyMedium: TextStyle(color: Color(0xFF4A4A4A)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF042940),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF049DBF),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF049DBF)),
      ),
      labelStyle: TextStyle(color: Color(0xFF042940)),
    ),
  );

  // Dark theme
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF049DBF),
      onPrimary: Colors.black,
      secondary: Color(0xFF8BBF56),
      onSecondary: Colors.black,
      tertiary: Color(0xFF8BBF56), // TO FIX: this should be a different color
      onTertiary: Colors.grey,
      surface: Color(0xFF042940),
      onSurface: Color(0xFFF2F2F2),
      error: Color(0xFFCF6679),
      onError: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF042940),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF042940),
      foregroundColor: Color(0xFFF2F2F2),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFF2F2F2)),
      bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF049DBF),
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF84BF5A),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF84BF5A)),
      ),
      labelStyle: TextStyle(color: Color(0xFFF2F2F2)),
    ),
  );
}
