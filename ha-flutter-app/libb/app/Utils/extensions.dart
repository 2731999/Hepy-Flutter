import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// this extension is convert hex color into Color equivalent,
// this extension is directly used when Color class is required
// ex. AppColor.colorPrimary.toColor() it will return color object
extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}


