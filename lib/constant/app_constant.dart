import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'text_style_decoration.dart';

class CustomAppTheme {
  CustomAppTheme._();
  static ThemeData lightTheme = ThemeData(
    fontFamily: TextStyleDecoration.fontFamily,
    colorScheme: lightColorScheme,
    useMaterial3: true,
    // textTheme: TextStyleDecoration.instance.getTextTheme,
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: TextStyleDecoration.fontFamily,
    colorScheme: darkColorScheme,
    useMaterial3: true,
    // textTheme: TextStyleDecoration.instance.getTextTheme,
  );
}
