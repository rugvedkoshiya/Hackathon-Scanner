import 'package:flutter/material.dart';

import '../main.dart';
import 'string_constant.dart';

class TextStyleDecoration {
  TextStyleDecoration._();
  static TextStyleDecoration instance = TextStyleDecoration._();

  // App default font
  static String? fontFamily = CustomFont.outfit;

  // Text theme
  TextTheme get getTextTheme => TextTheme(
        displayLarge: Theme.of(getContext).textTheme.displayLarge,
        displayMedium: Theme.of(getContext).textTheme.displayMedium,
        displaySmall: Theme.of(getContext).textTheme.displaySmall,
        headlineLarge: Theme.of(getContext).textTheme.headlineLarge,
        headlineMedium: Theme.of(getContext).textTheme.headlineMedium,
        headlineSmall: Theme.of(getContext).textTheme.headlineSmall,
        titleLarge: Theme.of(getContext).textTheme.titleLarge,
        titleMedium: Theme.of(getContext).textTheme.titleMedium,
        titleSmall: Theme.of(getContext).textTheme.titleSmall,
        bodyLarge: Theme.of(getContext).textTheme.bodyLarge,
        bodyMedium: Theme.of(getContext).textTheme.bodyMedium,
        bodySmall: Theme.of(getContext).textTheme.bodySmall,
        labelLarge: Theme.of(getContext).textTheme.labelLarge,
        labelMedium: Theme.of(getContext).textTheme.labelMedium,
        labelSmall: Theme.of(getContext).textTheme.labelSmall,
      );
}
