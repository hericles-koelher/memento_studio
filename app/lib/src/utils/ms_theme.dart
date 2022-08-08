import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memento_studio/src/utils.dart';

abstract class MSTheme {
  static const lightYellow = Color(0xFFFFEB99);
  static const mediumYellow = Color(0xFFFFDE5C);
  static const darkYellow = Color(0xFFFFCC00);
  static const lightPurple = Color(0xFFA486D5);
  static const darkPurple = Color(0xFF54318C);
  static const lilas = Color(0xFFD0B2FF);

  static final ThemeData purple = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: lightPurple,
      onPrimary: Colors.deepPurple.shade200,
      primaryContainer: Colors.deepPurple.shade400,
      onPrimaryContainer: Colors.white,
      secondary: darkPurple,
      onSecondary: Colors.deepPurple.shade100,
      secondaryContainer: lightPurple,
      onSecondaryContainer: Colors.deepPurple.shade800,
      tertiary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      foregroundColor: Colors.black,
      shape: const ContinuousRectangleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      titleTextStyle: GoogleFonts.spaceMonoTextTheme().titleLarge?.copyWith(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.spaceMonoTextTheme(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lilas,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(borderRadius)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: lilas,
        onPrimary: Colors.black,
        side: const BorderSide(
          color: Colors.black,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
      ),
    ),
    chipTheme: const ChipThemeData(
      side: BorderSide(
        color: Colors.black,
        width: borderWidth,
      ),
    ),
  );
}
