import 'package:game_imposter/core/controllers/system_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../data/ad_unit_ids.dart';

/// المتحكم الرئيسي لإدارة الإعلانات
/// يقوم بعمل preload لجميع أنواع الإعلانات ويوفرها جاهزة للاستخدام الفوري
class AdsManagerController extends GetxController {
  // --- Private State ---
  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  bool _isShowingFullScreenAd = false;

  // --- Banner Preload Pool ---
  /// قائمة البانرات الجاهزة للاستخدام (preloaded)
  final List<BannerAd> _preloadedBanners = [];
  
  /// قائمة الإعلانات المستطيلة المتوسطة الجاهزة للاستخدام (preloaded medium rectangle)
  final List<BannerAd> _preloadedMediumRectangles = [];

  /// عدد البانرات التي يتم تحميلها مسبقاً بشكل دائم
  static const int _bannerPoolSize = 2;
  static const int _mediumRectanglePoolSize = 1;

  // --- Config Helper ---
  SystemController get _systemController => Get.find<SystemController>();

  @override
  void onInit() {
    super.onInit();
    _initializeMobileAds();
  }

  Future<void> _initializeMobileAds() async {
    await MobileAds.instance.initialize();

    // Preload all ad types
    if (_systemController.apiConfig.enableAppOpenAd) {
      loadAppOpenAd(showAfterLoad: true);
    }
    if (_systemController.apiConfig.enableInterstitialAd) {
      loadInterstitialAd();
    }
    if (_systemController.apiConfig.enableBannerAd) {
      _fillBannerPool();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  APP OPEN AD
  // ═══════════════════════════════════════════════════════════════

  void loadAppOpenAd({bool showAfterLoad = false}) {
    if (!_systemController.apiConfig.enableAppOpenAd) return;

    AppOpenAd.load(
      adUnitId: AdUnitIds.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          if (showAfterLoad) {
            showAppOpenAd();
          }
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (!_systemController.apiConfig.enableAppOpenAd) return;

    if (_appOpenAd == null) {
      loadAppOpenAd();
      return;
    }

    if (_isShowingFullScreenAd) return;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingFullScreenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingFullScreenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd(); // Preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingFullScreenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  // ═══════════════════════════════════════════════════════════════
  //  INTERSTITIAL AD
  // ═══════════════════════════════════════════════════════════════

  void loadInterstitialAd() {
    if (!_systemController.apiConfig.enableInterstitialAd) return;

    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({Function? onAdDismissed}) {
    if (!_systemController.apiConfig.enableInterstitialAd) {
      onAdDismissed?.call();
      return;
    }

    if (_interstitialAd == null) {
      loadInterstitialAd();
      onAdDismissed?.call();
      return;
    }

    if (_isShowingFullScreenAd) {
      onAdDismissed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingFullScreenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingFullScreenAd = false;
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // Preload next
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingFullScreenAd = false;
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        onAdDismissed?.call();
      },
    );

    _interstitialAd!.show();
  }

  // ═══════════════════════════════════════════════════════════════
  //  BANNER AD POOL (Preload System)
  // ═══════════════════════════════════════════════════════════════

  /// تعبئة Pool البانرات المحملة مسبقاً للحجمين
  void _fillBannerPool() {
    while (_preloadedBanners.length < _bannerPoolSize) {
      _preloadSingleBanner(adSize: AdSize.banner);
    }
    while (_preloadedMediumRectangles.length < _mediumRectanglePoolSize) {
      _preloadSingleBanner(adSize: AdSize.mediumRectangle);
    }
  }

  /// تحميل بانر واحد وإضافته للـ Pool المناسب
  void _preloadSingleBanner({required AdSize adSize}) {
    final bannerAd = BannerAd(
      adUnitId: AdUnitIds.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // تمت إضافة البانر بنجاح، لا حاجة لفعل شيء إضافي
          // البانر جاهز في الـ Pool
        },
        onAdFailedToLoad: (ad, error) {
          print('BannerAd ($adSize) preload failed: $error');
          if (adSize.width == AdSize.mediumRectangle.width &&
              adSize.height == AdSize.mediumRectangle.height) {
            _preloadedMediumRectangles.remove(ad);
          } else {
            _preloadedBanners.remove(ad);
          }
          ad.dispose();
        },
      ),
    );

    if (adSize.width == AdSize.mediumRectangle.width &&
        adSize.height == AdSize.mediumRectangle.height) {
      _preloadedMediumRectangles.add(bannerAd);
    } else {
      _preloadedBanners.add(bannerAd);
    }
    bannerAd.load();
  }

  BannerAd? getPreloadedBanner({AdSize adSize = AdSize.banner}) {
    if (!_systemController.apiConfig.enableBannerAd) return null;

    if (adSize.width == AdSize.mediumRectangle.width &&
        adSize.height == AdSize.mediumRectangle.height) {
      if (_preloadedMediumRectangles.isNotEmpty) {
        final ad = _preloadedMediumRectangles.removeAt(0);
        // بعد أخذ واحد، نحمّل واحد جديد بنفس الحجم ليبقى الـ Pool ممتلئ
        _preloadSingleBanner(adSize: AdSize.mediumRectangle);
        return ad;
      }
    } else {
      if (_preloadedBanners.isNotEmpty) {
        final ad = _preloadedBanners.removeAt(0);
        // بعد أخذ واحد، نحمّل واحد جديد بنفس الحجم ليبقى الـ Pool ممتلئ
        _preloadSingleBanner(adSize: AdSize.banner);
        return ad;
      }
    }

    // لا يوجد بانرات جاهزة بالحجم المطلوب، سنعيد null والـ Widget سيحمّل بنفسه
    // ونعيد ملء الـ Pools للمحاولة القادمة
    _fillBannerPool();
    return null;
  }

  @override
  void onClose() {
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
    for (final ad in _preloadedBanners) {
      ad.dispose();
    }
    _preloadedBanners.clear();
    for (final ad in _preloadedMediumRectangles) {
      ad.dispose();
    }
    _preloadedMediumRectangles.clear();
    super.onClose();
  }
}
