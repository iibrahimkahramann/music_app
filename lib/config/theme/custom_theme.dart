import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme(context),
    );
  }

  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Color.fromARGB(153, 41, 45, 50);
  static const Color accentColor = Color.fromARGB(255, 251, 37, 118);
  static const Color backgroundColor = Colors.black;
  static const Color boldColor = Colors.white;
  static const Color mediumColor = Colors.white;
  static const Color regularColor = Color.fromARGB(255, 142, 142, 142);

  static TextTheme textTheme(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextTheme(
      bodyLarge: TextStyle(
        fontSize: height * 0.03,
        fontWeight: FontWeight.bold,
        color: boldColor,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: height * 0.017,
        fontWeight: FontWeight.bold,
        color: mediumColor,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: height * 0.015,
        fontWeight: FontWeight.bold,
        color: regularColor,
      ),
    );
  }

  static BoxDecoration customBoxDecoration({
    Color color = secondaryColor,
    double borderRadius = 8.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
