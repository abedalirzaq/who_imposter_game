import 'package:shared_preferences/shared_preferences.dart';

/// خدمة تتبع توقيت آخر تحميل لكل إعلان بانر بحسب الـ slotId
/// تمنع تحميل نفس البانر أكثر من مرة خلال الفترة المحددة في الإعدادات
class BannerAdCacheService {
  static const String _prefix = 'banner_last_load_';

  /// يتحقق إذا كان مسموحاً بتحميل إعلان جديد للـ slotId المحدد
  /// [slotId] معرف موضع الإعلان (مثال: 'home_bottom', 'voting_bottom')
  /// [refreshMinutes] المدة المسموح بعدها بإعادة التحميل (من ApiConfig)
  static Future<bool> canRefresh(String slotId, int refreshMinutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_prefix$slotId';
      final lastLoadMs = prefs.getInt(key);

      if (lastLoadMs == null) return true; // أول مرة يتم التحميل

      final lastLoad = DateTime.fromMillisecondsSinceEpoch(lastLoadMs);
      final now = DateTime.now();
      final diff = now.difference(lastLoad);

      return diff.inMinutes >= refreshMinutes;
    } catch (_) {
      return true; // في حالة أي خطأ، نسمح بالتحميل
    }
  }

  /// يحدّث توقيت آخر تحميل لـ slotId بعد نجاح تحميل الإعلان
  static Future<void> markLoaded(String slotId) async {
    print("markLoaded $slotId ==============");
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_prefix$slotId';
      await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  /// يمسح توقيت إعلان معين (للاختبار أو التجديد اليدوي)
  static Future<void> clearSlot(String slotId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefix$slotId');
    } catch (_) {}
  }

  /// يمسح توقيتات جميع الإعلانات (للاختبار)
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (_) {}
  }
}
