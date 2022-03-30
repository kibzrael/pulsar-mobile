import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/settings.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult? connectivity;

  bool get noConnection => connectivity == ConnectivityResult.none;

  bool dataSaver;

  MediaQuality mediaQuality;

  Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;

  Resolution resolution = Resolution.medium;

  ConnectivityProvider({required this.dataSaver, required this.mediaQuality}) {
    initialize();
  }

  initialize() async {
    connectivity = await Connectivity().checkConnectivity();
    connectivityStream.listen(connectivityListener);
    notifyListeners();
  }

  connectivityListener(ConnectivityResult result) {
    connectivity = result;
    if (mediaQuality == MediaQuality.auto) {
      if (result == ConnectivityResult.wifi) {
        resolution = dataSaver ? Resolution.medium : Resolution.high;
      } else if (result == ConnectivityResult.mobile) {
        resolution = dataSaver ? Resolution.low : Resolution.medium;
      }
    } else {
      resolution = mediaQuality == MediaQuality.low
          ? Resolution.low
          : mediaQuality == MediaQuality.medium
              ? Resolution.medium
              : Resolution.high;
    }
    notifyListeners();
  }
}

enum Resolution {
  low,
  medium,
  high,
}
