import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkController extends GetxController {
  var dark = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    dark.value = prefs.getBool('is_dark') ?? true;
  }

  void toggleDark(bool val) async {
    dark.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark', val);
  }
}
