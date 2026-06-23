import 'package:flutter/material.dart';
import 'package:game_imposter/features/dark_mode/theme_service.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool? isEnabled;
  final IconData? icon;

  const GameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isEnabled,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectiveEnabled = isEnabled ?? (onPressed != null);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate colors based on theme mode and enabled state
    final Color bgColor = effectiveEnabled
        ? (isPrimary
              ? (isDark ? ThemeService.getAccentColor(context) : Colors.blue)
              : Colors.grey.withValues(alpha: 0.5))
        : Colors.white54;

    final Color txtColor = effectiveEnabled
        ? (isPrimary
              ? (isDark ? Colors.black : Colors.white)
              : (isDark ? Colors.white : Colors.black))
        : isDark ? ThemeService.getTextColorInsideButton(context) : Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: txtColor,
            minimumSize: const Size(double.infinity, 55),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: effectiveEnabled && isPrimary ? 10 : 0,
            shadowColor: bgColor.withValues(alpha: 0.5),
          ),
          onPressed: onPressed,
          child: icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: txtColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: txtColor,
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: txtColor,
                  ),
                ),
        ),
      ),
    );
  }
}
