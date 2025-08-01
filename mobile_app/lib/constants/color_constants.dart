import 'package:flutter/material.dart';

/// Universal color constants for the Memora application
/// Based on the design system theme palette
class AppColors {
  // Primary Theme Colors
  static const Color primary = Color(0xFF390797);           // Deep Purple
  static const Color primaryLight = Color(0xFFA0C4FD);      // Light Sky Blue  
  static const Color primaryDark = Color(0xFF1c1c84);       // Deep Navy
  static const Color onPrimary = Color(0xFFFFFFFF);         // White text on primary
  // Secondary Theme Colors
  static const Color secondary = Color(0xFFA0C4FD);         // Light Sky Blue
  static const Color accent = Color(0xFFC3B1E1);            // Soft Lavender
  static const Color lightAccent = Color(0xFFECE2FD);       // Light Soft Lavender
  static const Color onSecondary = Color(0xFF000000);       // Black text on secondary
  
  // Info/Calm Colors
  static const Color info = Color(0xFF2B3F99);              // Calm Navy
  static const Color infoLight = Color(0xFFA0C4FD);         // Light Sky Blue variant
  static const Color onInfo = Color(0xFFFFFFFF);            // White text on info
  
  // Deep Theme Colors
  static const Color deep = Color(0xFF1c1c84);              // Deep Navy
  static const Color onDeep = Color(0xFFFFFFFF);            // White text on deep
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);        // White background
  static const Color surface = Color(0xFFFFFFFF);           // White surface
  static const Color surfaceVariant = Color(0xFFF8FAFC);    // Light grey surface
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2B3F99);       // Calm Navy text
  static const Color textSecondary = Color(0xFF390797);     // Deep Purple text
  static const Color onSurface = Color(0xFF1A1A1A);         // Dark text on surface
  static const Color onSurfaceVariant = Color(0xFF757575);  // Grey text variant
  
  // Semantic colors
  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF39A45D);
  static const Color successBackground = Color(0xFFD3F4D6);
  static const Color warning = Color(0xFFFF9800);
  
  // Outline and shadow
  static const Color outline = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
}

/// Backward compatibility - Patient specific colors
/// @deprecated Use AppColors instead
class PatientColors {
  // Primary colors mapped to new theme
  static const Color primary = AppColors.primary;
  static const Color primaryLight = AppColors.primaryLight;
  static const Color primaryDark = AppColors.primaryDark;
  static const Color onPrimary = AppColors.onPrimary;
  
  // Surface colors
  static const Color background = AppColors.surfaceVariant;
  static const Color surface = AppColors.surface;
  static const Color onSurface = AppColors.onSurface;
  static const Color onSurfaceVariant = AppColors.onSurfaceVariant;
  
  // Semantic colors
  static const Color error = AppColors.error;
  static const Color success = AppColors.success;
  static const Color successBackground = AppColors.successBackground;
  static const Color warning = AppColors.warning;
  static const Color info = AppColors.info;
  
  // Outline and shadow
  static const Color outline = AppColors.outline;
  static const Color shadow = AppColors.shadow;
  
  // Legacy colors (keeping for backwards compatibility)
  static const Color primaryBlue = AppColors.info;          // Calm Navy
  static const Color lightBlue = AppColors.primaryLight;    // Light Sky Blue
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
class AppMaterialColors {
  // Primary Deep Purple Swatch
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF390797,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(0xFF390797), // Deep Purple - Primary color
      600: Color(0xFF330689),
      700: Color(0xFF2C057A),
      800: Color(0xFF24046C),
      900: Color(0xFF1A0350),
    },
  );
  
  // Secondary Light Sky Blue Swatch
  static const MaterialColor secondarySwatch = MaterialColor(
    0xFFA0C4FD,
    <int, Color>{
      50: Color(0xFFF3F7FF),
      100: Color(0xFFE1EBFE),
      200: Color(0xFFCDDEFD),
      300: Color(0xFFB8D1FC),
      400: Color(0xFFA9C7FB),
      500: Color(0xFFA0C4FD), // Light Sky Blue - Secondary color
      600: Color(0xFF98BEFD),
      700: Color(0xFF8FB6FC),
      800: Color(0xFF85AFFB),
      900: Color(0xFF74A2FA),
    },
  );
  
  // Calm Navy Info Swatch
  static const MaterialColor infoSwatch = MaterialColor(
    0xFF2B3F99,
    <int, Color>{
      50: Color(0xFFE8EBF7),
      100: Color(0xFFC5CEEB),
      200: Color(0xFF9EADDE),
      300: Color(0xFF778CD0),
      400: Color(0xFF5A74C6),
      500: Color(0xFF2B3F99), // Calm Navy - Info color
      600: Color(0xFF2A3B94),
      700: Color(0xFF26348A),
      800: Color(0xFF222E80),
      900: Color(0xFF1A226E),
    },
  );
  
  // Deep Navy Swatch
  static const MaterialColor deepSwatch = MaterialColor(
    0xFF1c1c84,
    <int, Color>{
      50: Color(0xFFE5E5F4),
      100: Color(0xFFBFBFE4),
      200: Color(0xFF9494D3),
      300: Color(0xFF6969C1),
      400: Color(0xFF4848B4),
      500: Color(0xFF1c1c84), // Deep Navy color
      600: Color(0xFF191979),
      700: Color(0xFF15156C),
      800: Color(0xFF111160),
      900: Color(0xFF0A0A4B),
    },
  );
}

/// Backward compatibility Material Colors
/// @deprecated Use AppMaterialColors instead
class PatientMaterialColor {
  static const MaterialColor primarySwatch = AppMaterialColors.infoSwatch;
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
