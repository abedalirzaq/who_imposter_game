import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controller/game_controller.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../model/player_model.dart';
import '../widgets/next_button.dart';

class RevealRoleScreen extends StatefulWidget {
  const RevealRoleScreen({super.key});

  @override
  State<RevealRoleScreen> createState() => _RevealRoleScreenState();
}

class _RevealRoleScreenState extends State<RevealRoleScreen> {
  final GameController controller = Get.find<GameController>();
  bool _isRevealed = false;

  void _onRevealToggle() {
    setState(() {
      _isRevealed = !_isRevealed;
    });
  }

  void _onNext() {
    setState(() {
      _isRevealed = false;
    });
    controller.nextReveal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1c2528), Color.fromARGB(255, 0, 0, 0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            if (await DialogUtils.showExitDialog()) {
              Get.back();
            }
          },
          child: SafeArea(
            child: Obx(() {
              final player = controller.currentPlayer;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isRevealed
                    ? _buildRevealedView(player)
                    : _buildHiddenView(player),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenView(PlayerModel player) {
    return Column(
      key: ValueKey('hidden_${player.id}'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Iconsax.eye_slash, size: 80, color: Colors.white54),
        const SizedBox(height: 20),
        const Text(
          "مرر الهاتف إلى",
          style: TextStyle(fontSize: 24, color: Colors.white70),
        ),
        Text(
          player.name,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 40),
        GameButton(text: "انقر للإظهار", onPressed: _onRevealToggle),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "تأكد أن لا أحد يرى الشاشة غيرك!",
            style: TextStyle(color: Colors.redAccent, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedView(PlayerModel player) {
    return Column(
      key: ValueKey('revealed_${player.id}'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "أهلاً ${player.name}",
          style: const TextStyle(fontSize: 24, color: Colors.white70),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: player.isImposter ? Colors.redAccent : Colors.greenAccent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                player.isImposter ? "أنت الامبوستر!" : "الكلمة هي",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: player.isImposter ? Colors.redAccent : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                player.isImposter
                    ? "حاول أن لا يتم كشفك"
                    : controller.secretWord,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: player.isImposter
                      ? Colors.white70
                      : Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        GameButton(text: "أخفِ الإجابة والتالي", onPressed: _onNext),
      ],
    );
  }
}
