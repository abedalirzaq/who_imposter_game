import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/controllers/system_controller.dart';
import 'core/services/local_storage_service.dart';
import 'features/dark_mode/dark_controller.dart';
import 'features/dark_mode/theme_service.dart';
import 'features/game/controller/game_controller.dart';
import 'features/game/model/game_state_model.dart';
import 'features/game/view/screens/players_setup_screen.dart';
import 'features/game/view/screens/category_selection_screen.dart';
import 'features/game/view/screens/reveal_role_screen.dart';
import 'features/game/view/screens/question_round_screen.dart';
import 'features/game/view/screens/free_question_screen.dart';
import 'features/game/view/screens/voting_screen.dart';
import 'features/game/view/screens/result_screen.dart';
import 'features/game/view/screens/splash_screen.dart';

import 'features/ads_manager/controller/ads_manager_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  Get.put(DarkController()); // تهيئة متحكم الوضع الليلي
  Get.put(SystemController()); // يجب حقنه أولاً لأن AdsManager يعتمد عليه
  Get.put(AdsManagerController());
  Get.put(GameController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();

    return Obx(() {
      return GetMaterialApp(
        title: 'مين الامبوستر ؟ ',
        debugShowCheckedModeBanner: false,
        theme: themeService.lightTheme,
        darkTheme: themeService.darkTheme,
        themeMode: themeService.themeMode,
        home: const SplashScreen(),
      );
    });
  }
}

class MainGameNavigation extends StatelessWidget {
  const MainGameNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();

    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: _getScreenForPhase(controller.phase.value),
      );
    });
  }

  Widget _getScreenForPhase(GamePhase phase) {
    switch (phase) {
      case GamePhase.categorySelection:
        return CategorySelectionScreen(key: const ValueKey('category'));
      case GamePhase.setup:
        return PlayersSetupScreen(key: const ValueKey('setup'));
      case GamePhase.reveal:
        return RevealRoleScreen(key: const ValueKey('reveal'));
      case GamePhase.questionRound:
        return QuestionRoundScreen(key: const ValueKey('question'));
      case GamePhase.freeRound:
        return FreeQuestionScreen(key: const ValueKey('free'));
      case GamePhase.voting:
        return VotingScreen(key: const ValueKey('voting'));
      case GamePhase.result:
        return ResultScreen(key: const ValueKey('result'));
    }
  }
}
