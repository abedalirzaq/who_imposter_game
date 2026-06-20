import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/game_controller.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../widgets/next_button.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});

  final GameController controller = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    final mostVoted = controller.mostVotedPlayer;
    final didWin = controller.didPlayersWin;
    final isTie = mostVoted == null;
    final skipped = controller.skippedVoting;

    String titleMessage = "";

    if (skipped) {
      titleMessage = "تم تخطّي التصويت";
    } else if (isTie) {
      titleMessage = "تعادل في التصويت! الامبوستر فاز!";
    } else if (didWin) {
      titleMessage = "اللاعبون فازوا! 🎉";
    } else {
      titleMessage = "الامبوستر فاز! 😈";
    }

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (await DialogUtils.showExitDialog()) {
            Get.back();
          }
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
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleMessage,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: skipped ? Colors.grey : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "الامبوستر الحقيقي هو:",
                        style: TextStyle(fontSize: 24, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.imposterName,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white54),
                      const SizedBox(height: 20),
                      const Text(
                        "الكلمة كانت:",
                        style: TextStyle(fontSize: 24, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.secretWord,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                GameButton(
                  text: "العب مرة أخرى",
                  onPressed: () => controller.restartGame(),
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
