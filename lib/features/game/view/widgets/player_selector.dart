import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../model/player_model.dart';
import 'player_card.dart';

class PlayerSelector extends StatelessWidget {
  final List<PlayerModel> players;
  final String? selectedId;
  final List<String> excludedIds;
  final Function(String) onSelect;

  const PlayerSelector({
    super.key,
    required this.players,
    this.selectedId,
    this.excludedIds = const [],
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final selectablePlayers = players
        .where((p) => !excludedIds.contains(p.id))
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectablePlayers.length,
      itemBuilder: (context, index) {
        final player = selectablePlayers[index];
        final isSelected = player.id == selectedId;
        return PlayerCard(
          name: player.name,
          isSelected: isSelected,
          onTap: () => onSelect(player.id),
        ).animate().scale(
          duration: 400.ms,
          delay: (index * 100).ms,
          curve: Curves.easeOutBack,
        );
      },
    );
  }
}
