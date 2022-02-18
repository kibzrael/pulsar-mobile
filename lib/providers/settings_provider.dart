import 'package:flutter/cupertino.dart';
import 'package:pulsar/classes/settings.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  Box box = Hive.box('settings');

  Settings settings = Settings();

  SettingsProvider() {
    if (box.isOpen) {
      if (box.isNotEmpty) {
        settings = Settings.fromJson(box.toMap() as Map<String, dynamic>);
      }
    }
  }

  save() {
    // use hive to save json
    settings.toJson().forEach((key, value) {
      box.put(key, value);
    });
    notifyListeners();
  }
}
