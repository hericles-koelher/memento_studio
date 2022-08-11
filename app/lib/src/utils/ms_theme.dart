import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memento_studio/src/utils.dart';

abstract class MSTheme {
  static const lightPurple = Color(0xFFD0B2FF);
  static const darkPurple = Color(0xFF54318C);

  static final ThemeData light = ThemeData.light().copyWith(
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
      backgroundColor: lightPurple,
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
        primary: lightPurple,
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
    // drawerTheme: DrawerThemeData(backgroundColor: lilas),
  );
}
