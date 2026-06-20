import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_imposter/features/ads_manager/view/widgets/banner_ad_widget.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax/iconsax.dart';
import '../../controller/game_controller.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../widgets/next_button.dart';

class QuestionRoundScreen extends StatelessWidget {
  QuestionRoundScreen({super.key});

  final GameController controller = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAdWidget(
        slotId: 'question_round_bottom',
        adSize: AdSize.banner,
      ),
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 10),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                      'اختر اللاعبين',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .moveY(
                                      begin: -10,
                                      end: 0,
                                      curve: Curves.easeOutQuad,
                                    ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () async {
                          if (await DialogUtils.showExitDialog()) {
                            Get.back();
                          }
                        },
                        child:
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(Iconsax.logout4, color: Colors.black),
                                  SizedBox(width: 3),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                shape: BoxShape.circle,
                              ),
                            ).animate().scale(
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Obx(() {
                    final pair = controller.currentQuestionPair;
                    final asker = pair['asker']!;
                    final asked = pair['asked']!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            final isIncoming =
                                child.key == ValueKey(asker.id + asked.id);
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, isIncoming ? -1 : 1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey(asker.id + asked.id),
                            children: [
                              Text(
                                asker.name,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "يسأل",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Icon(
                                Icons.arrow_downward,
                                size: 40,
                                color: Colors.white54,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                asked.name,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        GameButton(
                          text: "التالي",
                          onPressed: () => controller.nextQuestion(),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
