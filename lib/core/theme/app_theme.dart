

import 'package:flutter/material.dart';

class AppTheme {
  
  static final ColorScheme _customColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF3F51B5), 
    onPrimary: const Color(0xFFFFFFFF), 
    primaryContainer: const Color(0xFFC5CAE9), 
    onPrimaryContainer: const Color(0xFF1A237E), 
    secondary: const Color(0xFFFFC107), 
    onSecondary: const Color(0xFF000000), 
    secondaryContainer: const Color(0xFFFFECB3), 
    onSecondaryContainer: const Color(0xFFFF8F00), 
    tertiary: const Color(0xFF4DD0E1), 
    onTertiary: const Color(0xFF000000), 
    tertiaryContainer: const Color(0xFFB2EBF2), 
    onTertiaryContainer: const Color(0xFF006064), 
    error: const Color(0xFFB00020), 
    onError: const Color(0xFFFFFFFF), 
    background: const Color(0xFFFAFAFA), 
    onBackground: const Color(0xFF212121), 
    surface: const Color(0xFFFFFFFF), 
    onSurface: const Color(0xFF212121), 
    surfaceVariant: const Color(0xFFE0E0E0), 
    onSurfaceVariant: const Color(0xFF424242), 
    outline: const Color(0xFFBDBDBD), 
    shadow: const Color(0xFF000000), 
    inverseSurface: const Color(0xFF424242), 
    onInverseSurface: const Color(0xFFF5F5F5), 
    inversePrimary: const Color(0xFF9FA8DA), 
    scrim: const Color(0xFF000000), 
    surfaceTint: const Color(0xFF3F51B5), 
  );

  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _customColorScheme, 
      appBarTheme: AppBarTheme(
        backgroundColor: _customColorScheme.primary, 
        foregroundColor: _customColorScheme.onPrimary, 
        elevation: 4,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _customColorScheme.secondary, 
        foregroundColor: _customColorScheme.onSecondary, 
      ),
      cardTheme: CardThemeData( 
        color: _customColorScheme.surface, 
        surfaceTintColor: _customColorScheme.surfaceTint, 
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: _customColorScheme.primaryContainer, 
        checkmarkColor: _customColorScheme.onPrimaryContainer, 
        labelStyle: TextStyle(color: _customColorScheme.onSurface), 
      ),
      listTileTheme: ListTileThemeData(
        tileColor: _customColorScheme.surface, 
        selectedTileColor: _customColorScheme.primaryContainer, 
        iconColor: _customColorScheme.onSurfaceVariant, 
        textColor: _customColorScheme.onSurface, 
      ),
      
      
    );
  }
}
