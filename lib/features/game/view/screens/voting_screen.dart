import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_imposter/features/dark_mode/dark_controller.dart';
import 'package:game_imposter/features/dark_mode/theme_service.dart';
import 'package:get/get.dart';
import '../../controller/game_controller.dart';
import '../../model/game_state_model.dart';
import '../../model/player_model.dart';
import '../widgets/next_button.dart';
import '../../../../core/utils/dialog_utils.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (controller) {
        return Obx(() {
          final isDark = Get.find<DarkController>().dark.value;
          isDark;
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
              leadingWidth: 90,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: InkWell(
                  onTap: () {
                    controller.phase.value = GamePhase.freeRound;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeService.getAccentColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "تراجع",
                        style: TextStyle(
                          color: ThemeService.getTextColorInsideButton(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              ),
              title: Text(
                "وقت التصويت!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ThemeService.getTextColor(context),
                ),
              ).animate().fadeIn(duration: 600.ms).moveY(begin: -10, end: 0),
              backgroundColor: Colors.transparent,
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
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "كل لاعب يختار من يعتقد انه الامبوستر",
                            style: TextStyle(
                              fontSize: 20,
                              color: ThemeService.getTextColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                        ),
                        Expanded(
                          child:
                              ListView.builder(
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
                                  )
                                  .animate()
                                  .fadeIn(delay: (100).ms, duration: 400.ms)
                                  .scale(
                                    delay: (50).ms,
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
                                             SnackBar(
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
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  ThemeService.getAccentColor(
                                                    context,
                                                  ),
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
        });
      },
    );
  }
}

class _VoterTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: index == controller.players.length - 1 ? 100 : 0,
      ),
      child: Obx(() {
        final votedForId = controller.playerVotes[voter.id];
        final hasVoted = votedForId != null;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: hasVoted
              ? (isDark
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.green.withValues(alpha: 0.12))
              : ThemeService.getCardColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      voter.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: hasVoted
                            ? isDark ? Colors.white : Colors.black
                            : ThemeService.getTextColor(context),
                      ),
                    ),
                    if (hasVoted)
                      const Icon(Icons.check_circle, color: Colors.blue)
                    else
                      Icon(Icons.hourglass_empty, color: ThemeService.getSubtextColor(context), size: 20),
                  ],
                ),
                if (hasVoted)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Text(
                      "صوت لـ: ${controller.players.firstWhereOrNull((p) => p.id == votedForId)?.name ?? ''}",
                      style:  TextStyle(color: ThemeService.getAccentColor(context), fontSize: 14),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Text(
                      "لم يصوّت بعد",
                      style: TextStyle(color: ThemeService.getSubtextColor(context), fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.players
                      .where((p) => p.id != voter.id)
                      .map((p) {
                    final isSelected = p.id == votedForId;
                    return InkWell(
                      onTap: () {
                        controller.vote(voter.id, p.id);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeService.getAccentColor(context)
                              : Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? ThemeService.getAccentColor(context)
                                : ThemeService.getSubtextColor(context).withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: ThemeService.getAccentColor(context).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          p.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? ThemeService.getTextColorInsideButton(context)
                                : ThemeService.getTextColor(context),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
