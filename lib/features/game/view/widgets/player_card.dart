import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_imposter/features/dark_mode/theme_service.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final bool isSelected;
  final VoidCallback? onTap;

  const PlayerCard({
    super.key,
    required this.name,
    this.onRemove,
    this.onEdit,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(1)
              : ThemeService.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? ThemeService.getTextColorInsideButton(context)
                        : ThemeService.getTextColor(context),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (onEdit != null)
              InkWell(
                onTap: onEdit,
                child:  FaIcon(FontAwesomeIcons.penToSquare, color: ThemeService.getAccentColor(context)),
              ),
            const SizedBox(width: 15),
            if (onRemove != null)
              InkWell(
                onTap: onRemove,
                child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.redAccent),
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
