import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_imposter/features/dark_mode/dark_controller.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final DarkController darkController = Get.find<DarkController>();
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Obx(() {
      final isDark = darkController.dark.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CupertinoSwitch(
              value: isDark,
              onChanged: (val) {
                darkController.toggleDark(val);
              },
              // activeColor: const Color(0xFF334155), // Premium deep slate for dark mode track
              // trackColor:  Theme.of(context).unselectedWidgetColor,    // لون المسار
              trackColor: Colors.blue,
              activeColor: Colors.yellowAccent,
            ),
            Positioned.fill(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isDark
                    ? (isRTL ? Alignment.centerLeft : Alignment.centerRight)
                    : (isRTL ? Alignment.centerRight : Alignment.centerLeft),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 9),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      darkController.toggleDark(!darkController.dark.value);
                    },
                    child: darkController.dark.value
                        ? Icon(
                      Icons.dark_mode,
                      color: Colors.black,
                      size: 20,
                    )
                        : Icon(
                      Icons.wb_sunny,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
