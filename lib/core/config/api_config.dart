class ApiConfig {
  String version = "1.0.0";

  // --- Ads Configuration ---
  bool enableBannerAd = true;
  bool enableInterstitialAd = true;
  bool enableAppOpenAd = true;

  /// مدة التجديد الخاصة بإعلانات البانر بالدقائق
  /// لن يتم تحميل إعلان جديد لنفس الموضع إلا بعد مرور هذه المدة
  int bannerRefreshMinutes = 2;

  // --- Developer Info ---
  String developerName = "PEA Automation";
  String developerUrl = "https://www.linkedin.com/company/primeera-automation-pea";

  // --- Update Configuration ---
  String updateUrl = "https://www.linkedin.com/company/primeera-automation-pea";
  int appStatus = 0; // 0: Normal, 1: Optional Update, 2: Forced Update
  String updateMessage = "يوجد تحديث جديد للتطبيق، يرجى التحديث للمتابعة";

  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('version')) {
      version = map['version'];
    }
    if (map.containsKey('enable_banner_ad')) {
      enableBannerAd = map['enable_banner_ad'] ?? true;
    }
    if (map.containsKey('enable_interstitial_ad')) {
      enableInterstitialAd = map['enable_interstitial_ad'] ?? true;
    }
    if (map.containsKey('enable_app_open_ad')) {
      enableAppOpenAd = map['enable_app_open_ad'] ?? true;
    }
    if (map.containsKey('banner_refresh_minutes')) {
      bannerRefreshMinutes = map['banner_refresh_minutes'] ?? 10;
    }
    if (map.containsKey('developer_name')) {
      developerName = map['developer_name'] ?? "PEA Automation";
    }
    if (map.containsKey('developer_url')) {
      developerUrl = map['developer_url'] ?? "https://www.linkedin.com/company/primeera-automation-pea";
    }
    if (map.containsKey('update_url')) {
      updateUrl = map['update_url'] ?? "https://play.google.com/store/apps";
    }
    if (map.containsKey('app_status')) {
      appStatus = map['app_status'] ?? 0;
    }
    if (map.containsKey('update_message')) {
      updateMessage =
          map['update_message'] ??
          "يوجد تحديث جديد للتطبيق، يرجى التحديث للمتابعة";
    }
  }
}
