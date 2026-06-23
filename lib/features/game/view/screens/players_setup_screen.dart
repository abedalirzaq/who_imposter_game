import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_imposter/features/dark_mode/dark_controller.dart';
import 'package:game_imposter/features/dark_mode/theme_service.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controller/game_controller.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../widgets/player_card.dart';
import '../widgets/next_button.dart';

class PlayersSetupScreen extends StatelessWidget {
  PlayersSetupScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final RxString _inputText = ''.obs;

  void _addPlayer(GameController controller) {
    if (_nameController.text.isNotEmpty) {
      controller.addPlayer(_nameController.text);
      _nameController.clear();
      _inputText.value = '';
    }
  }

  void _editPlayer(
    BuildContext context,
    GameController controller,
    String id,
    String currentName,
  ) {
    final editController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "تعديل الاسم",
            style: TextStyle(color: ThemeService.getTextColor(context)),
          ),
          content: TextField(
            controller: editController,
            style: TextStyle(color: ThemeService.getTextColor(context)),
            decoration: InputDecoration(
              hintText: "اسم اللاعب...",
              hintStyle: TextStyle(
                color: ThemeService.getSubtextColor(context),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إلغاء",
                style: TextStyle(color: ThemeService.getSubtextColor(context)),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.updatePlayerName(id, editController.text);
                Navigator.pop(context);
              },
              child: Text(
                "حفظ",
                style: TextStyle(color: ThemeService.getAccentColor(context)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final darkController = Get.find<DarkController>();

    return Obx(() {
      // Access value to register dependency
      final isDark = darkController.dark.value;
      isDark;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            if (await DialogUtils.showExitDialog(showAd: false)) {
              Get.back();
            }
          },
          child: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                              'اختر اللاعبين',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    ThemeService.getTextColor(
                                                      context,
                                                    ),
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

                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () async {
                                  if (await DialogUtils.showExitDialog(
                                    showAd: false,
                                  )) {
                                    Get.back();
                                  }
                                },
                                child:
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: ThemeService.getAccentColor(
                                          context,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child:  Row(
                                        children: [
                                          Icon(
                                            Iconsax.logout,
                                            color: ThemeService.getTextColorInsideButton(context),
                                          ),
                                          SizedBox(width: 3),
                                        ],
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

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child:
                            Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _nameController,
                                        onChanged: (val) {
                                          _inputText.value = val;
                                        },
                                        style: TextStyle(
                                          color: ThemeService.getTextColor(
                                            context,
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "أدخل اسم اللاعب...",
                                          hintStyle: TextStyle(
                                            color: ThemeService.getSubtextColor(
                                              context,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: ThemeService.getCardColor(
                                            context,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                        ),
                                        onSubmitted: (_) =>
                                            _addPlayer(controller),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    FloatingActionButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      onPressed: () => _addPlayer(controller),
                                      backgroundColor:
                                          ThemeService.getAccentColor(context),
                                      child:  FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: ThemeService.getTextColorInsideButton(context),
                                      ),
                                    ).animate().scale(
                                      delay: 400.ms,
                                      duration: 400.ms,
                                      curve: Curves.easeOutBack,
                                    ),
                                  ],
                                )
                                .animate()
                                .fadeIn(delay: 200.ms, duration: 500.ms)
                                .moveX(begin: -20, end: 0),
                      ),
                      Expanded(
                        child: Obx(() {
                          if (controller.players.isEmpty) {
                            return Center(
                              child: Text(
                                "أضف لاعبين لتبدأ المتعة! (الحد الأدنى 3)",
                                style: TextStyle(
                                  color: ThemeService.getSubtextColor(context),
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ).animate().fadeIn(duration: 800.ms);
                          }
                          return ListView.builder(
                            itemCount: controller.players.length,
                            itemBuilder: (context, index) {
                              final player = controller.players[index];
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: index == controller.players.length - 1
                                      ? 130
                                      : 0,
                                ),
                                child:
                                    PlayerCard(
                                          name: player.name,
                                          onRemove: () => controller
                                              .removePlayer(player.id),
                                          onEdit: () => _editPlayer(
                                            context,
                                            controller,
                                            player.id,
                                            player.name,
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(
                                          duration: 400.ms,
                                          delay: (index * 100).ms,
                                        )
                                        .moveX(
                                          begin: 30,
                                          end: 0,
                                          delay: (index * 100).ms,
                                          curve: Curves.easeOutQuad,
                                        ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Obx(
                  () {
                    final bool isInputNotEmpty = _inputText.value.isNotEmpty;
                    return GameButton(
                      text: isInputNotEmpty ? "إضافة اللاعب" : "ابدأ اللعبة",
                      icon: isInputNotEmpty ? Icons.add : null,
                      isEnabled: isInputNotEmpty ? true : controller.canStart,
                      onPressed: () {
                        if (isInputNotEmpty) {
                          _addPlayer(controller);
                        } else {
                          if (controller.canStart) {
                            controller.startGame();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "يجب إضافة 3 لاعبين على الأقل للبدء ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: ThemeService.getAccentColor(
                                  context,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: 110,
                                  left: 20,
                                  right: 20,
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ).animate().scale(
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
