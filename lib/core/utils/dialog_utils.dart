import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/game/controller/game_controller.dart';
import '../../features/ads_manager/controller/ads_manager_controller.dart';
import '../../features/dark_mode/theme_service.dart';

class DialogUtils {
  static Future<bool> showExitDialog({bool showAd = true}) async {
    final context = Get.context;
    if (context == null) return false;

    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'تنبيه',
              style: TextStyle(
                color: ThemeService.getTextColor(context),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            content: Text(
              'هل أنت متأكد من الخروج؟ سيتم فقدان تقدم اللعبة الحالي.',
              style: TextStyle(color: ThemeService.getSubtextColor(context)),
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'لا',
                  style: TextStyle(
                    color: ThemeService.getSubtextColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeService.getAccentColor(context),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  try {
                    Get.find<GameController>().restartGame();
                    Get.back();

                    if (showAd) {
                      final adsController = Get.find<AdsManagerController>();
                      adsController.showInterstitialAd(onAdDismissed: () {});
                    }
                  } catch (_) {
                    // Fallback
                    try {
                      Get.find<GameController>().restartGame();
                    } catch (_) {}
                    Get.back();
                  }
                },
                child:  Text(
                  'نعم',
                  style: TextStyle(fontWeight: FontWeight.bold, color: ThemeService.getTextColorInsideButton(context)),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  static Future<bool> showSkipVotingDialog() async {
    final context = Get.context;
    if (context == null) return false;

    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'تحذير ⚠️',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            content: Text(
              'في حال تخطّي التصويت، لن تتمكّن من معرفة ما إذا كان الامبوستر قد فاز أم خسر.\n\nهل تريد المتابعة؟',
              style: TextStyle(color: ThemeService.getSubtextColor(context), fontSize: 15),
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: ThemeService.getSubtextColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'تخطّي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
