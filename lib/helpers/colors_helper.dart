import 'package:flutter/material.dart';

class ColorHelper {
  static Color toColorFromValue(int colorValue) {
    return Color(colorValue ?? 0xFFFFFF);
  }

  static int toValueFromColor(Color color) {
    return color.value;
  }
}
