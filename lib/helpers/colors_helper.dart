import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorHelper {
  static Color toColorFromValue(int colorValue) {
    return Color(colorValue ?? 0xFFFFFF);
  }

  static int toValueFromColor(Color color) {
    return color.value;
  }

  static void setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.green, //or set color with: Color(0xFF0000FF)
    ));
  }
}
