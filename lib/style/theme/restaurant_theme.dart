import 'package:flutter/material.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_typography.dart';

class RestaurantTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: RestaurantColors.orange.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: RestaurantColors.orange.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: RestaurantTypography.displayLarge,
      displayMedium: RestaurantTypography.displayMedium,
      displaySmall: RestaurantTypography.displaySmall,
      headlineLarge: RestaurantTypography.headlineLarge,
      headlineMedium: RestaurantTypography.headlineMedium,
      headlineSmall: RestaurantTypography.headlineSmall,
      titleLarge: RestaurantTypography.titleLarge,
      titleMedium: RestaurantTypography.titleMedium,
      titleSmall: RestaurantTypography.titleSmall,
      bodyLarge: RestaurantTypography.bodyLargeBold,
      bodyMedium: RestaurantTypography.bodyLargeMedium,
      bodySmall: RestaurantTypography.bodyLargeRegular,
      labelLarge: RestaurantTypography.labelLarge,
      labelMedium: RestaurantTypography.labelMedium,
      labelSmall: RestaurantTypography.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(toolbarTextStyle: _textTheme.titleLarge);
  }
}
