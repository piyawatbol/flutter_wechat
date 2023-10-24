import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textGoogleStyle({double? fontSize, Color? color, FontWeight? fontWeight}) {
  return GoogleFonts.kanit(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
  );
}
