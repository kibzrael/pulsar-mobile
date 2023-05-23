import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> languages =
    AppLocalizations.supportedLocales.map((e) => e.languageCode).toList();

AppLocalizations local(BuildContext context) => AppLocalizations.of(context)!;

Future<AppLocalizations> get l10n async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? localePref = prefs.getString('locale');
  List<Locale>? saved;
  if (localePref != null) {
    saved = [Locale(localePref)];
  }
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  List<Locale> preferred = widgetsBinding.platformDispatcher.locales;
  List<Locale> supported = AppLocalizations.supportedLocales;
  Locale locale = basicLocaleListResolution(saved ?? preferred, supported);
  return await AppLocalizations.delegate.load(locale);
}

class LocalizationProvider extends ChangeNotifier {
  String get defaultLanguage => Platform.localeName.split('_').first;

  late Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    saveLocale();
    notifyListeners();
  }

  late SharedPreferences prefs;

  LocalizationProvider() {
    _locale =
        Locale(languages.contains(defaultLanguage) ? defaultLanguage : 'en');
    loadLocale();
  }

  saveLocale() async {
    await prefs.setString('locale', locale.languageCode);
  }

  loadLocale() async {
    prefs = await SharedPreferences.getInstance();
    String? localePref = prefs.getString('locale');
    if (localePref != null) {
      _locale = Locale(localePref);
    }
    notifyListeners();
  }
}
