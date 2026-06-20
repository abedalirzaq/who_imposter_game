# Ads Manager Feature

هذا المجلد يحتوي على نظام إدارة الإعلانات (Google Mobile Ads) للتطبيق.

## المكونات الرئيسية

| الملف | الوظيفة |
|---|---|
| `controller/ads_manager_controller.dart` | المتحكم الرئيسي - preload وعرض جميع أنواع الإعلانات |
| `view/widgets/banner_ad_widget.dart` | ويدجيت ذكي لعرض إعلانات البانر مع نظام تحديث ذكي |
| `data/ad_unit_ids.dart` | معرفات الإعلانات (Ad Unit IDs) |
| `data/banner_ad_cache_service.dart` | خدمة تتبع توقيت آخر تحميل لكل موضع بانر |

## نظام Preload

يتم تحميل الإعلانات مسبقاً عند بدء التطبيق:
- **App Open Ad**: يتم تحميله وعرضه فوراً عند فتح التطبيق، ثم يتم تحميل واحد جديد بعد إغلاقه.
- **Interstitial Ad**: يتم تحميله مسبقاً وجاهز للعرض الفوري عند الحاجة.
- **Banner Ads**: يتم تحميل **3 بانرات** مسبقاً في Pool جاهز. عند استخدام بانر، يتم تحميل واحد جديد تلقائياً ليبقى الـ Pool ممتلئاً.

---

## أماكن ظهور الإعلان الكامل (Interstitial) حالياً
1.  **عند الخروج من اللعبة**: يظهر الإعلان بعد الضغط على "نعم" في نافذة تأكيد الخروج (`DialogUtils`).
2.  **بعد انتهاء التصويت**: يظهر الإعلان مباشرة بعد أن يقوم آخر لاعب بالتصويت وقبل الانتقال لشاشة النتائج (`GameController`).

---

## كيفية الاستخدام

### 1. إعلان فتح التطبيق (App Open Ad)
يعمل تلقائياً عند فتح التطبيق. لاستدعائه يدوياً:
```dart
Get.find<AdsManagerController>().showAppOpenAd();
```

### 2. إعلان الشاشة الكاملة (Interstitial Ad)
```dart
Get.find<AdsManagerController>().showInterstitialAd(
  onAdDismissed: () {
    // الكود الذي سيعمل بعد إغلاق الإعلان
    print('تم إغلاق الإعلان');
  },
);
```

### 3. إعلان البانر الذكي (Banner Ad - Smart Cache)
كل `BannerAdWidget` مستقل ويدار بـ `slotId` فريد. **لن يُعاد تحميل الإعلان في نفس الموضع** إلا بعد مرور `bannerRefreshMinutes` من `ApiConfig` (افتراضي: 10 دقائق).

```dart
// كل موضع له slotId فريد خاص به
Scaffold(
  bottomNavigationBar: SafeArea(
    child: BannerAdWidget(slotId: 'home_bottom'),
  ),
  body: Column(
    children: [
      BannerAdWidget(slotId: 'home_top'),
      Expanded(child: YourContent()),
    ],
  ),
)
```

**IDs الأماكن المستخدمة حالياً:**
| slotId | الشاشة |
|---|---|
| `category_screen_bottom` | شاشة اختيار الفئة |
| `question_round_bottom` | شاشة جولة التساؤلات |
| `free_question_bottom` | شاشة الجولة الحرة |

---

## التحكم بتشغيل/إيقاف الإعلانات

يتم التحكم بكل نوع إعلان بشكل مستقل عبر `ApiConfig` في `SystemController`:

```dart
// إيقاف إعلانات البانر فقط
Get.find<SystemController>().apiConfig.enableBannerAd = false;

// إيقاف إعلانات الشاشة الكاملة فقط
Get.find<SystemController>().apiConfig.enableInterstitialAd = false;

// إيقاف إعلان فتح التطبيق فقط
Get.find<SystemController>().apiConfig.enableAppOpenAd = false;
```

**عند استقبال البيانات من الـ API:**
```json
{
  "version": "1.0.0",
  "enable_banner_ad": true,
  "enable_interstitial_ad": true,
  "enable_app_open_ad": false
}
```

---

## ملاحظات مهمة
- معرفات الإعلانات الحالية هي **معرفات تجريبية** من جوجل. يجب استبدالها بمعرفات حقيقية عند النشر في ملف `data/ad_unit_ids.dart`.
- `SystemController` يجب أن يُحقن **قبل** `AdsManagerController` في `main.dart`.
