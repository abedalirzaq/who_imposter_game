import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        padding: EdgeInsets.symmetric(vertical: 13,horizontal: 5),
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                          ),
              ),
            ),
            SizedBox(width: 10),
            if (onEdit != null)
            InkWell(
              onTap: onEdit,
              child: FaIcon(FontAwesomeIcons.penToSquare, color: Colors.amber),
            ),
                        SizedBox(width: 15),

              if (onRemove != null)
               InkWell(
                onTap: onRemove,
                child: FaIcon(FontAwesomeIcons.trashCan, color: Colors.redAccent)),
                            SizedBox(width: 10),

            ]

      
    )));
  }
}
