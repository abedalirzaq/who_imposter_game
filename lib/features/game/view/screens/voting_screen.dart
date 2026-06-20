import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controller/game_controller.dart';
import '../../model/game_state_model.dart';
import '../../model/player_model.dart';
import '../widgets/player_selector.dart';
import '../widgets/next_button.dart';
import '../../../../core/utils/dialog_utils.dart';

class VotingScreen extends StatelessWidget {
  VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 90,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: () {
                  controller.phase.value = GamePhase.freeRound;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "تراجع",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            ),
            title: Text(
              "وقت التصويت!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 600.ms).moveY(begin: -10, end: 0),
            backgroundColor: const Color(0xFF1c2528),
            elevation: 0,
            centerTitle: true,
          ),
          body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) return;
              controller.phase.value = GamePhase.freeRound;
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "كل لاعب يختار من يعتقد انه الامبوستر",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.players.length,
                          itemBuilder: (context, index) {
                            final voter = controller.players[index];
                            return _VoterTile(
                              key: ValueKey(voter.id),
                              voter: voter,
                              controller: controller,
                              index: index,
                            );
                          },
                        ).animate()
          .fadeIn(delay: ( 100).ms, duration: 400.ms)
          .scale(
            delay: ( 50).ms,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      final everyoneVoted =
                          controller.votedPlayers.length ==
                          controller.players.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            // زر التخطي (رمادي)
                            Expanded(
                              flex: 1,
                              child:
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade700,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(0, 55),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final confirmed =
                                            await DialogUtils.showSkipVotingDialog();
                                        if (confirmed) {
                                          controller.skippedVoting = true;
                                          controller.showResultWithAd();
                                        }
                                      },
                                      child: const Text(
                                        'تخطّي',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ).animate().scale(
                                    duration: 400.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                            ),
                            // زر إظهار النتائج
                            Expanded(
                              flex: 3,
                              child:
                                  GameButton(
                                    text: "إظهار النتائج",
                                    isEnabled: everyoneVoted,
                                    onPressed: () {
                                      if (everyoneVoted) {
                                        controller.showResultWithAd();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "يجب على الجميع التصويت",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Colors.yellowAccent,
                                            margin: EdgeInsets.only(
                                              bottom: 85,
                                              left: 20,
                                              right: 20,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ).animate().scale(
                                    duration: 400.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VoterTile extends StatefulWidget {
  final PlayerModel voter;
  final GameController controller;
  final int index;

  const _VoterTile({
    super.key,
    required this.voter,
    required this.controller,
    required this.index,
  });

  @override
  State<_VoterTile> createState() => _VoterTileState();
}

class _VoterTileState extends State<_VoterTile> {
  final ExpansionTileController _expansionController =
      ExpansionTileController();
  bool _hasAnimated = false;

  @override
  Widget build(BuildContext context) {
    // الـ widget الأساسي بدون أنيميشن
    Widget child = Container(
      margin: EdgeInsets.only(
        bottom: widget.index == widget.controller.players.length - 1 ? 100 : 0,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Obx(() {
          final votedForId = widget.controller.playerVotes[widget.voter.id];
          final hasVoted = votedForId != null;

          return ExpansionTile(
            controller: _expansionController,
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            title: Text(
              widget.voter.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: hasVoted ? Colors.greenAccent : Colors.white,
              ),
            ),
            subtitle: hasVoted
                ? Text(
                    "صوت لـ: ${widget.controller.players.firstWhereOrNull((p) => p.id == votedForId)?.name ?? ''} ✅",
                    style: const TextStyle(color: Colors.greenAccent),
                  )
                : const Text(
                    "لم يصوّت بعد ⏳",
                    style: TextStyle(color: Colors.white70),
                  ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlayerSelector(
                  players: widget.controller.players,
                  excludedIds: [widget.voter.id],
                  selectedId: votedForId,
                  onSelect: (selectedId) {
                    widget.controller.vote(widget.voter.id, selectedId);
                    _expansionController.collapse();
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );

    // إذا لم يتم عمل الأنيميشن مسبقاً لهذا الـ State، نقوم بعمله
    

    // إذا سبق عمل الأنيميشن (في Rebuilds قادمة)، نرجع الـ child مباشرة
    return child;
  }
}
