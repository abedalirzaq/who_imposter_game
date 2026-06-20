import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_imposter/features/ads_manager/view/widgets/banner_ad_widget.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax/iconsax.dart';
import '../../controller/game_controller.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../widgets/player_selector.dart';
import '../widgets/next_button.dart';

class FreeQuestionScreen extends StatelessWidget {
  FreeQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (controller) {
        final currentPlayerId = controller.currentTurnPlayerId;
        final currentPlayer = controller.players.firstWhereOrNull(
          (p) => p.id == currentPlayerId,
        );

        if (currentPlayer == null) return const Scaffold();

        return Scaffold(
          backgroundColor: Color(0xFF1c2528),

          body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) return;
              if (await DialogUtils.showExitDialog()) {
                Get.back();
              }
            },
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // زر العودة
                          // زر التصويت
                          InkWell(
                            onTap: () async {
                              if (await DialogUtils.showExitDialog()) {
                                Get.back();
                              }
                            },
                            child:
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.yellowAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Iconsax.logout,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 3),
                                    ],
                                  ),
                                ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.easeOutBack,
                                  delay: 200.ms,
                                ),
                          ),

                          // العنوان
                          const SizedBox(),

                          // زر التصويت
                          InkWell(
                            onTap: () => controller.startVoting(),
                            child:
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.yellowAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "التصويت",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Iconsax.tick_circle,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.easeOutBack,
                                  delay: 200.ms,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "دور ${currentPlayer.name} للسؤال",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "اختر لاعباً لتسأله:",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PlayerSelector(
                            players: controller.players,
                            selectedId: controller.currentTurnAskedPlayerId,
                            excludedIds: [
                              currentPlayer.id,
                              if (controller.previousAskerId != null)
                                controller.previousAskerId!,
                            ],
                            onSelect: (id) =>
                                controller.checkSelectNextPlayer(id),
                          ),
                        ),
                      ),
                    ),
                    GameButton(
                      text: "تأكيد وإنتقال الدور",
                      onPressed: controller.currentTurnAskedPlayerId != null
                          ? () => controller.confirmSelectNextPlayer()
                          : null,
                    ),
                    const SizedBox(height: 30),
                    BannerAdWidget(
                      slotId: 'free_question_bottom',
                      adSize: AdSize.banner,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
