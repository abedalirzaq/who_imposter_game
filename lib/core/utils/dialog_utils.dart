import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/game/controller/game_controller.dart';
import '../../features/ads_manager/controller/ads_manager_controller.dart';

class DialogUtils {
  static Future<bool> showExitDialog() async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF1c2528),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'تنبيه',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            content: const Text(
              'هل أنت متأكد من الخروج؟ سيتم فقدان تقدم اللعبة الحالي.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'لا',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  try {
                    final adsController = Get.find<AdsManagerController>();
                    Get.find<GameController>().restartGame();
                    Get.back();

                    adsController.showInterstitialAd(onAdDismissed: () {});
                  } catch (_) {
                    // Fallback
                    try {
                      Get.find<GameController>().restartGame();
                    } catch (_) {}
                    Get.back();
                  }
                },
                child: const Text(
                  'نعم',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  static Future<bool> showSkipVotingDialog() async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF1c2528),
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
            content: const Text(
              'في حال تخطّي التصويت، لن تتمكّن من معرفة ما إذا كان الامبوستر قد فاز أم خسر.\n\nهل تريد المتابعة؟',
              style: TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.white54,
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
