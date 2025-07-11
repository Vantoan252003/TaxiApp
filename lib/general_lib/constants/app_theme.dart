// App Theme Configuration
import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Monochrome Design
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFF999999);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color borderColor = Color(0xFFE5E5E5);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Accent colors for minimal use
  static const Color accentBlue = Color(0xFF007AFF);
  static const Color successGreen = Color(0xFF34C759);
  static const Color warningRed = Color(0xFFFF3B30);

  // Text Styles - Clean Typography
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: darkGray,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: mediumGray,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: lightGray,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // Button Styles - Minimalist Design
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryBlack,
    foregroundColor: primaryWhite,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
    textStyle: buttonText,
  );

  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryBlack,
    backgroundColor: primaryWhite,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    side: const BorderSide(color: borderColor, width: 1),
    elevation: 0,
    textStyle: buttonText,
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: primaryBlack,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: buttonText,
  );

  // Card Styles - Clean & Subtle
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderColor, width: 0.5),
    boxShadow: [
      BoxShadow(
        color: primaryBlack.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration subtleCardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: borderColor, width: 0.5),
  );

  // Input Field Styles
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: backgroundColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryBlack, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: body2,
  );

  // App Bar Style
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: primaryWhite,
    foregroundColor: primaryBlack,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryBlack,
    ),
    iconTheme: IconThemeData(color: primaryBlack),
  );

  // Icon Styles
  static const IconThemeData iconTheme = IconThemeData(
    color: primaryBlack,
    size: 24,
  );

  static const IconThemeData secondaryIconTheme = IconThemeData(
    color: mediumGray,
    size: 20,
  );

  // Divider Style
  static const Divider divider = Divider(
    color: borderColor,
    thickness: 0.5,
    height: 1,
  );
}
