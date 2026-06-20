import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controller/game_controller.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../widgets/player_card.dart';
import '../widgets/next_button.dart';

class PlayersSetupScreen extends StatelessWidget {
  PlayersSetupScreen({super.key});

  final TextEditingController _nameController = TextEditingController();

  void _addPlayer(GameController controller) {
    if (_nameController.text.isNotEmpty) {
      controller.addPlayer(_nameController.text);
      _nameController.clear();
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
          backgroundColor: const Color(0xFF302B63),
          title: const Text(
            "تعديل الاسم",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: editController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "اسم اللاعب...",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "إلغاء",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.updatePlayerName(id, editController.text);
                Navigator.pop(context);
              },
              child: const Text(
                "حفظ",
                style: TextStyle(color: Colors.orangeAccent),
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

    return Scaffold(
      backgroundColor: const Color(0xFF1c2528),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (await DialogUtils.showExitDialog()) {
            Get.back();
          }
        },
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
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
                                        Icon(
                                          Iconsax.logout,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 3,)
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "أدخل اسم اللاعب...",
                                        hintStyle: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.1,
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
                                    backgroundColor: Colors.yellow,
                                    child: const FaIcon(
                                      FontAwesomeIcons.plus,
                                      color: Colors.black,
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
                          return const Center(
                            child: Text(
                              "أضف لاعبين لتبدأ المتعة! (الحد الأدنى 3)",
                              style: TextStyle(
                                color: Colors.white54,
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
                              margin: EdgeInsets.only(bottom: index == controller.players.length - 1 ? 130 : 0),
                              child: PlayerCard(
                                    name: player.name,
                                    onRemove: () =>
                                        controller.removePlayer(player.id),
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
                () => GameButton(
                  text: "ابدأ اللعبة",
                  isEnabled: controller.canStart,
                  onPressed: () {
                    if (controller.canStart) {
                      controller.startGame();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
                          backgroundColor: Colors.yellowAccent,
                          margin: EdgeInsets.only(
                            bottom: 110,
                            left: 20,
                            right: 20,
                          ),
                        ),
                      );
                    }
                  },
                ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
