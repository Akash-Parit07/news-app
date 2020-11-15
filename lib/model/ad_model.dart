import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '';

class Ad {
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
      testDevices: <String>[],
      keywords: <String>['wallpapers', 'sports', 'business'],
      birthday: new DateTime.now(),
      childDirected: true);

  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: "ca-app-pub-1244654157371716/4028907675",
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: "ca-app-pub-1244654157371716/4192559207",
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }
}
