import 'package:flutter/material.dart';

/// Color constants for the Patient module
class PatientColors {
  // Material Design inspired colors
  static const Color primary = Color(0xFF2B3F99);
  static const Color primaryLight = Color(0xFFA0C4FD);
  static const Color primaryDark = Color(0xFF1A226E);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Surface colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceVariant = Color(0xFF757575);
  
  // Semantic colors
  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF4CAF50);
  static const Color successBackground = Color(0xFFE8F5E8);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Outline and shadow
  static const Color outline = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  
  // Legacy colors (keeping for backwards compatibility)
  static const Color primaryBlue = Color(0xFF2B3F99);
  static const Color lightBlue = Color(0xFFA0C4FD);
  static const Color backgroundGrey = Color(0xFFF8FAFC);
  
  // Accent Colors
  static const Color accentOrange = Color(0xFFFF8A65);
  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentIndigo = Color(0xFF3F51B5);
  
  // Semantic Colors (legacy)
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFE57373);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Text Colors (legacy)
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  // Background Colors (legacy)
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Activity Colors (for different activity types)
  static const Color activityMeal = Color(0xFFFF8A65);      // Orange for meals
  static const Color activityNutrition = Color(0xFFFF8A65); // Orange for nutrition
  static const Color activityMedicine = Color(0xFF66BB6A);   // Green for medicine
  static const Color activityExercise = Color(0xFF42A5F5);   // Blue for exercise
  static const Color activityPhysical = Color(0xFF42A5F5);   // Blue for physical activities
  static const Color activitySleep = Color(0xFF9C27B0);      // Purple for sleep
  static const Color activityHygiene = Color(0xFF26C6DA);    // Cyan for hygiene
  static const Color activitySocial = Color(0xFFFFCA28);     // Yellow for social activities
  static const Color activityMeditation = Color(0xFFE1BEE7); // Light purple for meditation
  static const Color activityCreativity = Color(0xFFFFE0B2); // Light orange for creativity
  
  // Game Level Colors
  static const Color gameBeginner = Color(0xFFA0C4FD);
  static const Color gameIntermediate = Color(0xFF66BB6A);
  static const Color gameAdvanced = Color(0xFFFF8A65);
  
  // Navigation Colors
  static const Color navigationActive = Color(0xFF2B3F99);
  static const Color navigationInactive = Color(0xFF9E9E9E);
  
  // Shadow and Border Colors
  static const Color shadowLight = Color(0x0F000000);        // 6% opacity black
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
}

/// Material Color Swatches for theme usage
class PatientMaterialColor {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF2B3F99,
    <int, Color>{
      50: Color(0xFFE8EBF7),
      100: Color(0xFFC5CEEB),
      200: Color(0xFF9EADDE),
      300: Color(0xFF778CD0),
      400: Color(0xFF5A74C6),
      500: Color(0xFF2B3F99), // Primary color
      600: Color(0xFF2A3B94),
      700: Color(0xFF26348A),
      800: Color(0xFF222E80),
      900: Color(0xFF1A226E),
    },
  );
}

/// Predefined color combinations for common UI elements
class PatientColorCombinations {
  // Card color combinations
  static const Map<String, Color> taskCards = {
    'background': PatientColors.cardBackground,
    'border': PatientColors.borderLight,
    'text': PatientColors.textPrimary,
    'accent': PatientColors.primaryBlue,
  };
  
  static const Map<String, Color> completedTaskCards = {
    'background': PatientColors.successGreen,
    'border': PatientColors.successGreen,
    'text': PatientColors.backgroundWhite,
    'accent': PatientColors.backgroundWhite,
  };
  
  // Button color combinations
  static const Map<String, Color> primaryButton = {
    'background': PatientColors.primaryBlue,
    'text': PatientColors.backgroundWhite,
    'border': PatientColors.primaryBlue,
  };
  
  static const Map<String, Color> secondaryButton = {
    'background': PatientColors.lightBlue,
    'text': PatientColors.primaryBlue,
    'border': PatientColors.lightBlue,
  };
}
