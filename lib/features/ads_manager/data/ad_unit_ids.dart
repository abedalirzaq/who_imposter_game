import 'dart:io';

class AdUnitIds {
  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3527427928264280/6994655580'; // Test ID
    } else if (Platform.isIOS) {
      return 'unsupported_ios'; // Test ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3527427928264280/4104768366'; // Test ID
    } else if (Platform.isIOS) {
      return 'unsupported_ios'; // Test ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3527427928264280/5681573910'; // Test ID
    } else if (Platform.isIOS) {
      return 'unsupported_ios'; // Test ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
