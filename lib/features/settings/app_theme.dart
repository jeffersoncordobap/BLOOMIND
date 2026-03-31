import 'package:flutter/material.dart';

class AppTheme {
  // Colores base (Modo Claro)
  static const Color lightPrimary = Color(0xFF6A94C9);
  static const Color lightBackground = Color(
    0xFFF1F5F9,
  ); // Fondo gris azulado suave
  static const Color lightSurface = Colors.white; // Color de las tarjetas
  static const Color lightTextPrimary = Color(0xFF1E293B);

  // Colores base (Modo Oscuro)
  static const Color darkPrimary = Color(0xFF94B9E9);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        onPrimary: Colors.white,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        // Definimos un color de outline muy suave para que no parezca negro
        outline: Colors.black.withOpacity(0.08),
        shadow: Colors.black.withOpacity(0.04),
      ),
      scaffoldBackgroundColor: lightBackground,

      // --- ELIMINAR BORDES DE TARJETAS ---
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none, // <--- CRÍTICO: Sin borde
        ),
      ),

      // --- ELIMINAR BORDES DE BOTONES ELEVADOS ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          side: BorderSide.none, // <--- CRÍTICO: Sin borde
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // --- SUAVIZAR BORDES DE BOTONES OUTLINED (Los que tienen contorno) ---
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ), // Borde casi invisible
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: lightTextPrimary,
        ),
      ),

      // --- SUAVIZAR INPUTS (TextFields) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // <--- Sin borde negro al rededor
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.05),
          ), // Borde muy tenue
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightPrimary, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        surface: darkSurface,
        background: darkBackground,
        outline: Colors.white10,
      ),
      scaffoldBackgroundColor: darkBackground,

      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D3748),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: darkPrimary,
          foregroundColor: darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
