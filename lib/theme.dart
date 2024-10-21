import 'package:flutter/material.dart';

class GeckoTheme {
  static ThemeData get theme {
    return ThemeData(
      // Define the default brightness and colors
      brightness: Brightness.light,
      primaryColor: const Color(0xFF003366), // Dark blue for brand identity

      // Define the default font family
      fontFamily: 'Roboto', // Assuming "Roboto" as a modern typeface

      // Define the text styles
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003366), // Dark blue for major headlines
        ),
        headlineMedium: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00A99D), // Teal for sub headlines
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          color: Colors.black, // Default body text
        ),
        
        bodySmall: TextStyle(
          fontSize: 14.0,
          color: Colors.black, // Secondary body text
        ),
        
      ),

      // Button style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003366), // Dark blue for button background
          foregroundColor: Colors.white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded buttons
          ),
        ),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF003366), // Dark blue for app bar
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White app bar title
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // White icons in the app bar
        ),
      ),

      // Define the color scheme
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF003366), // Dark blue
        secondary: const Color(0xFF00A99D), // Teal
        error: Colors.redAccent, // Standard error color
        background: Colors.white, // Light background
      ),

      // Input decoration theme for forms and text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200], // Light grey background for input fields
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF00A99D), // Teal border for enabled fields
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF003366), // Dark blue for focused fields
          ),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[600], // Light grey hint text
        ),
      ),
    );
  }
}
