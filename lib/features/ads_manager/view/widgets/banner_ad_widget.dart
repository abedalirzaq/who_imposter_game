/// مهم جدا : اهن في مشلكة لاني حذفت بالغلط markLoaded الخاص بالكاش وتسجيل تاريخ جديد لاي عملية تحميل اعلان جديد
/// مهم جدا :::::::::::::::::::: لازم تصلحو

import 'package:flutter/material.dart';
import 'package:game_imposter/core/controllers/system_controller.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../controller/ads_manager_controller.dart';
import '../../data/ad_unit_ids.dart';
import '../../data/banner_ad_cache_service.dart';

/// ويدجيت بسيط لعرض إعلانات البانر مع نظام تحديث ذكي
///
/// المنطق:
/// 1. عند ظهور الـ Widget، يتحقق إذا مرت المدة المحددة (bannerRefreshMinutes) على آخر تحميل لهذا الـ slotId.
/// 2. إذا لم تمر المدة → لا يعرض أي إعلان (SizedBox.shrink).
/// 3. إذا مرت المدة أو أول مرة → يحمّل إعلاناً جديداً ويعرضه.
//// 
class BannerAdWidget extends StatefulWidget {
  final AdSize adSize;
  final String slotId;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
    required this.slotId
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _shouldShow = false;

  @override
  void initState() {
    super.initState();
    _checkAndLoad();
  }

  Future<void> _checkAndLoad() async {
    // هل الإعلانات مفعّلة؟
    try {
      final config = Get.find<SystemController>().apiConfig;
      if (!config.enableBannerAd) return;

      // هل مرّت المدة المطلوبة منذ آخر تحميل لهذا الموضع؟
      final canRefresh = await BannerAdCacheService.canRefresh(
        widget.slotId,
        config.bannerRefreshMinutes,
      );

      if (!mounted) return;

      if (canRefresh) {
        _shouldShow = true;
        _loadAd();
      }
      // إذا لم تمر المدة → لا نعرض شيئاً
    } catch (_) {
      // في حالة خطأ → حمّل احتياطياً
      if (mounted) {
        _shouldShow = true;
        _loadAd();
      }
    }
  }

  void _loadAd() {
    // حاول أخذ بانر preloaded من الـ Pool أولاً
    try {
      final adsController = Get.find<AdsManagerController>();
      final preloaded = adsController.getPreloadedBanner(adSize: widget.adSize);
      if (preloaded != null) {
        _bannerAd = preloaded;
        if (mounted) setState(() => _isLoaded = true);
        return;
      }
    } catch (_) {}

    // Fallback: تحميل مستقل
    _bannerAd = BannerAd(
      adUnitId: AdUnitIds.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    if (_isLoaded && _bannerAd != null) {
      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
