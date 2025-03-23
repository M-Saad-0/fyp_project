import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFFFF9800);

  static final ThemeData lightTheme = ThemeData(
      primaryTextTheme: TextTheme(
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        displaySmall: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      colorScheme: ColorScheme(
          surfaceContainerLow: const Color.fromARGB(255, 241, 235, 235),
          brightness: Brightness.light,
          primary: AppThemes.primaryColor,
          secondary: const Color(0xFF42A5F5),
          tertiary: Colors.white,
          surface: Colors.white,
          error: Colors.red.shade700,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onError: Colors.white,
          onTertiary: Colors.black87,
          onSurface: Colors.black54,
          onSurfaceVariant: Colors.grey[600]),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      tabBarTheme: const TabBarTheme(
          indicatorColor: primaryColor,
          labelColor: Color.fromARGB(135, 0, 0, 0)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 50),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        bodySmall: TextStyle(fontSize: 14, color: Colors.black45),
        headlineLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        labelSmall: TextStyle(fontSize: 18, color: Colors.black54),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: Color(0xFFD6D6D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      switchTheme: const SwitchThemeData(
          thumbColor: WidgetStatePropertyAll<Color>(primaryColor)),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: primaryColor));

  static final ThemeData darkTheme = ThemeData(
      primaryTextTheme: TextTheme(
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Colors.grey[400],
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          surfaceContainerLow: Colors.grey[850],
          primary: AppThemes.primaryColor,
          secondary: const Color(0xFF90CAF9),
          tertiary: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
          error: Colors.red.shade700,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onError: Colors.black,
          onTertiary: Colors.white70,
          onSurface: Colors.white60,
          onSurfaceVariant: Colors.grey[600]),
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      tabBarTheme: const TabBarTheme(
          indicatorColor: primaryColor,
          labelColor: Color.fromARGB(136, 255, 255, 255)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 50),
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.white60),
        bodySmall: TextStyle(fontSize: 14, color: Colors.white54),
        headlineLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
        labelSmall: TextStyle(fontSize: 18, color: Colors.white60),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1F1F1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      switchTheme: const SwitchThemeData(
          thumbColor: WidgetStatePropertyAll<Color>(primaryColor),
          trackColor: WidgetStatePropertyAll<Color>(Colors.black),
          overlayColor: WidgetStatePropertyAll<Color>(Colors.black),
          trackOutlineColor: WidgetStatePropertyAll<Color>(Colors.white60)),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: primaryColor));
}
