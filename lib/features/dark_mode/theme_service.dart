import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_imposter/features/dark_mode/dark_controller.dart';

class ThemeService {
  final DarkController darkController = Get.find<DarkController>();

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E88E5),
    scaffoldBackgroundColor: const Color(0xFFEBF3FC),
    textTheme: GoogleFonts.cairoTextTheme().apply(
      bodyColor: const Color(0xFF0F172A),
      displayColor: const Color(0xFF0F172A),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFFFFF),
      secondary: Color(0xFF42A5F5),
      surface: Color(0xFFE3F2FD),
      onPrimary: Color(0xFF1E88E5),
      onSurface: Color(0xFF0F172A),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6F2DBD),
    scaffoldBackgroundColor: const Color(0xFF1c2528),

    textTheme: GoogleFonts.cairoTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1c2528),
      secondary: Color(0xFFA663CC),
      surface: Color(0xFF302B63),
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
  );

  ThemeMode get themeMode =>
      darkController.dark.value ? ThemeMode.dark : ThemeMode.light;

  static List<Color> getGradientColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)];
    } else {
      return const [Color(0xFFFFFFFF), Color(0xFFBBDEFB)];
    }
  }

  static Color getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : const Color(0xFF0F172A);
  }

  static Color getSubtextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white70 : const Color(0xFF334155);
  }

  static Color getCardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: 0.1)
        : const Color(0xFFFFFFFF);
  }

  static Color getAccentColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.yellowAccent
        : const Color(0xFF1E88E5);
  }
  static Color getTextColorInsideButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.black
        :  Colors.white;
  }
}
