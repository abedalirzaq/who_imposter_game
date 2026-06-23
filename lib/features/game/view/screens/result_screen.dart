import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_imposter/features/dark_mode/dark_controller.dart';
import 'package:game_imposter/features/dark_mode/theme_service.dart';
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

    return Obx(() {
      final isDark = Get.find<DarkController>().dark.value;
      isDark;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            color: Colors.transparent,
            child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleMessage,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: skipped ? Colors.grey : ThemeService.getTextColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ThemeService.getCardColor(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "الامبوستر الحقيقي هو:",
                        style: TextStyle(fontSize: 24, color: ThemeService.getSubtextColor(context)),
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
                      Divider(color: Theme.of(context).dividerColor),
                      const SizedBox(height: 20),
                      Text(
                        "الكلمة كانت:",
                        style: TextStyle(fontSize: 24, color: ThemeService.getSubtextColor(context)),
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
  });
}
}
