import 'package:flutter/cupertino.dart';
import 'package:pulsar/classes/settings.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  Box box = Hive.box('settings');

  Settings settings = Settings();

  SettingsProvider() {
    if (box.isOpen) {
      if (box.isNotEmpty) {
        var boxContent = box.toMap();
        Map<String, dynamic> mapContent = {};
        boxContent
            .forEach((key, value) => mapContent.putIfAbsent(key, () => value));
        settings = Settings.fromJson(mapContent);
      }
    }
  }

  save({bool notify = true}) {
    // use hive to save json
    settings.toJson().forEach((key, value) {
      box.put(key, value);
    });
    if (notify) notifyListeners();
  }
}
