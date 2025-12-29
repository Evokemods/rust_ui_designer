import 'package:flutter/material.dart';

class ColorUtils {
  static String colorToUiColor(Color color) {
    double r = ((color.r * 255.0).round() & 0xff) / 255.0;
    double g = ((color.g * 255.0).round() & 0xff) / 255.0;
    double b = ((color.b * 255.0).round() & 0xff) / 255.0;
    double a = ((color.a * 255.0).round() & 0xff) / 255.0;
    return 'new UiColor(${r.toStringAsFixed(3)}f, ${g.toStringAsFixed(3)}f, ${b.toStringAsFixed(3)}f, ${a.toStringAsFixed(3)}f)';
  }

  static int colorToInt(Color color) {
    return color.toARGB32();
  }

  static Color intToColor(int value) {
    return Color(value);
  }
}
