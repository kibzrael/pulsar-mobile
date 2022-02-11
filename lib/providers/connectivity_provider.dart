import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult? connectivity;

  bool get noConnection => connectivity == ConnectivityResult.none;

  bool dataSaver;

  Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;

  Resolution resolution = Resolution.medium;

  ConnectivityProvider({required this.dataSaver}) {
    initialize();
  }

  initialize() async {
    connectivity = await Connectivity().checkConnectivity();
    connectivityStream.listen(connectivityListener);
    notifyListeners();
  }

  connectivityListener(ConnectivityResult result) {
    connectivity = result;
    if (result == ConnectivityResult.wifi) {
      resolution = dataSaver ? Resolution.medium : Resolution.high;
    } else if (result == ConnectivityResult.mobile) {
      resolution = dataSaver ? Resolution.low : Resolution.medium;
    }
    notifyListeners();
  }
}

enum Resolution {
  low,
  medium,
  high,
}
