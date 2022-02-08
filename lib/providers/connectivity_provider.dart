import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  late ConnectivityResult connectivity;

  Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;

  Resolution resolution = Resolution.medium;

  ConnectivityProvider() {
    initialize();
  }

  initialize() async {
    connectivity = await Connectivity().checkConnectivity();
    connectivityStream.listen(connectivityListener);
    notifyListeners();
  }

  connectivityListener(ConnectivityResult result) {
    connectivity = result;
    notifyListeners();
  }
}

enum Resolution {
  low,
  medium,
  high,
}
