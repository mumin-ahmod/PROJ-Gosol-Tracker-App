import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black87),

    // bodyText2: GoogleFonts.ubuntu(fontSize: 14, color: const Color(0xff64dd17)),
    headline1: GoogleFonts.encodeSans(
        fontSize: 25, color: Colors.black87, fontWeight: FontWeight.w600),
    headline2: GoogleFonts.encodeSans(
        fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
    headline3: GoogleFonts.encodeSans(
        fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w600),
    headline4: GoogleFonts.encodeSans(
        fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),

    headline5: GoogleFonts.encodeSans(
        fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w400),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        // backgroundColor: Color(0xFFdcedc8),
          ),
      textTheme: lightTextTheme,
    );
  }
}
