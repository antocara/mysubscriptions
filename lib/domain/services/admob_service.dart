import 'package:firebase_admob/firebase_admob.dart';

class AdmobService {
  static const APP_ID_ADMOB = "YOUR ID";

  static const INTERSTITIAL_FINANCE_ID = "ca-app-pub-ID";
  static const INTERSTITIAL_LAUNCH_APP_ID = "ca-app-pub-ID";

  static void initializeAdmob() {
    FirebaseAdMob.instance.initialize(appId: APP_ID_ADMOB);
  }

  void displayInterstitialFinance() {
    _displayInterstitial(_interstitialFinance);
  }

  void displayInterstitialLaunch() {
    _displayInterstitial(_interstitialLaunchApp);
  }

  void disposedInterstitialFinance() {
    _disposeInterstitial(_interstitialFinance);
  }

  void disposedInterstitialLaunch() {
    _disposeInterstitial(_interstitialLaunchApp);
  }

  void _displayInterstitial(InterstitialAd interstitial) {
    interstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }

  void _disposeInterstitial(InterstitialAd interstitial) {
    interstitial.dispose();
  }

  static MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'mysubscription'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  InterstitialAd _interstitialFinance = InterstitialAd(
    adUnitId: INTERSTITIAL_FINANCE_ID,
    targetingInfo: _targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  InterstitialAd _interstitialLaunchApp = InterstitialAd(
    adUnitId: INTERSTITIAL_LAUNCH_APP_ID,
    targetingInfo: _targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
}
