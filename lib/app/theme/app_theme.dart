import 'package:flutter/material.dart';
import 'package:melodia/app/theme/color.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    fontFamily: 'Montserrat',
    brightness: Brightness.dark, // Mode sombre par défaut
    primaryColor: AppColors.vividOrange,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.vividOrange,
      secondary: AppColors.lightOrange,
      surface: AppColors.darkBlueGray,
    ),

    scaffoldBackgroundColor: AppColors.darkBlueGray,

    textTheme: const TextTheme(
      // Titres
      headlineLarge: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        color: AppColors.vividOrange,
      ),
      headlineMedium: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),

      // Corps de texte
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),

      // Boutons
      labelLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.darkBlueGray,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}
