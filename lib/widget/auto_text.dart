import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoText extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final double? spaceHeight;
  final FontWeight? fontWeight;
  final double? minfontSize;
  final int? maxLines;
  final TextDecoration? textDecoration;
  final TextOverflow? overflow;
  AutoText(
    this.text, {
    this.textAlign,
    this.fontSize,
    this.color,
    this.spaceHeight,
    this.fontWeight,
    this.maxLines,
    this.minfontSize = 10,
    this.textDecoration,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      "$text",
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minfontSize!,
      overflow: overflow,
      style: GoogleFonts.kanit(
        textStyle: TextStyle(
          color: color,
          fontSize: fontSize,
          height: spaceHeight,
          fontWeight: fontWeight,
          decoration: textDecoration,
        ),
      ),
      // style: TextStyle(
      //   color: color,
      //   fontSize: fontSize,
      //   height: spaceHeight,
      //   fontWeight: fontWeight,
      //   decoration: textDecoration,
      // ),
    );
  }
}



