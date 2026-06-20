import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool? isEnabled;

  const GameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectiveEnabled = isEnabled ?? (onPressed != null);

    // Calculate colors based on the enabled state as requested
    final Color bgColor = effectiveEnabled
        ? (isPrimary ? Colors.yellow : Colors.grey.withOpacity(0.5))
        : Colors.white54;

    final Color txtColor = effectiveEnabled ? Colors.black : Colors.white;

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
            shadowColor: bgColor.withOpacity(0.5),
          ),
          onPressed: onPressed,
          child: Text(
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
