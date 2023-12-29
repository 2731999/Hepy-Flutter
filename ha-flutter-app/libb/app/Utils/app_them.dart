import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';

class AppThem {
  AppThem._privateConstructor();

  static AppThem get of => AppThem._privateConstructor();

  static Color inputBackground = const Color(0xffF2F2F3);
  static Color inputFocusBackground = const Color(0xffE1EEFF);
  static Color scaffoldBackground = Colors.grey.shade50;

  ThemeData themeData() {
    return ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        scaffoldBackgroundColor: scaffoldBackground,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColor.colorPrimary.toColor(), width: 1.0),
          ),
          focusColor: AppColor.colorPrimary.toColor().withOpacity(0.1),
          focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
            centerTitle: true,
            backgroundColor: Colors.grey.shade50,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black,size: 24)));
  }
}
