import 'package:flutter/material.dart';

class UiColorsPresets {
  static const Map<String, Color> presets = {
    'Transparent': Color(0x00000000), // Fully transparent
    'Black': Color(0xFF000000),
    'White': Color(0xFFFFFFFF),
    'Red': Color(0xFFFF0000),
    'Green': Color(0xFF00FF00),
    'Blue': Color(0xFF0000FF),
    'Yellow': Color(0xFFFFFF00),
    'Orange': Color(0xFFFFA500),
    'Purple': Color(0xFF800080),
    'Dark Gray': Color(0xFF2A2A2A),   // Dark background
    'Gray': Color(0xFF5A5A5A),        // Medium gray
    'Light Gray': Color(0xFF808080),  // Light gray
  };

  static const List<String> basicColors = [
    'Transparent',
    'Black',
    'White',
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Orange',
    'Purple',
    'Dark Gray',
    'Gray',
    'Light Gray',
  ];
}
