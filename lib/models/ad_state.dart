import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get calendarViewBottomAd => Platform.isAndroid
      ? "ca-app-pub-1042536658048489/4283857849"
      : "ca-app-pub-3940256099942544/2934735716";

  String get calendarsViewBottomAd => Platform.isAndroid
      ? "ca-app-pub-1042536658048489/6982366893"
      : "ca-app-pub-3940256099942544/2934735716";
}
