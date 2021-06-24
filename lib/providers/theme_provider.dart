import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  buttonColor: Colors.deepPurpleAccent,
  accentColor: Colors.deepOrangeAccent,
  toggleableActiveColor: Colors.deepOrangeAccent,
  disabledColor: Colors.grey[300],
  dividerColor: Colors.grey[400],
  chipTheme: chipTheme(Brightness.light),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  indicatorColor: Colors.deepOrangeAccent,
  textSelectionTheme:
      TextSelectionThemeData(cursorColor: Colors.deepOrangeAccent),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[200],
      hintStyle: TextStyle(fontSize: 16.5, color: Colors.grey)),
  appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0.0,
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey),
  textTheme: textTheme(Brightness.light),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme(
      primary: Colors.blue,
      primaryVariant: Colors.deepPurpleAccent,
      secondary: Colors.deepOrangeAccent,
      secondaryVariant: Colors.deepOrange,
      surface: Colors.grey.shade50,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  buttonColor: Colors.deepPurpleAccent,
  accentColor: Colors.deepOrangeAccent,
  toggleableActiveColor: Colors.deepOrangeAccent,
  disabledColor: Colors.grey[850],
  dividerColor: Colors.grey[600],
  cardColor: Colors.grey[850],
  chipTheme: chipTheme(Brightness.dark),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  indicatorColor: Colors.deepOrangeAccent,
  textSelectionTheme:
      TextSelectionThemeData(cursorColor: Colors.deepOrangeAccent),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[850],
      hintStyle: TextStyle(fontSize: 16.5, color: Colors.grey[400])),
  appBarTheme: AppBarTheme(color: Colors.grey[900], elevation: 0.0),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      elevation: 0.0,
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey),
  textTheme: textTheme(Brightness.dark),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.grey[900],
  colorScheme: ColorScheme(
      primary: Colors.blue,
      primaryVariant: Colors.deepPurpleAccent,
      secondary: Colors.deepOrangeAccent,
      secondaryVariant: Colors.deepOrange,
      surface: Colors.grey[850]!.withOpacity(0.25),
      background: Colors.grey.shade900,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark),
);

TextTheme textTheme(Brightness brightness) => TextTheme(
    bodyText1: TextStyle(
      fontSize: 16.5,
      fontWeight: FontWeight.w500,
    ),
    headline1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.grey[brightness == Brightness.light ? 600 : 350],
    ),
    subtitle1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    subtitle2: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.grey[brightness == Brightness.light ? 500 : 400]));

ChipThemeData chipTheme(Brightness brightness) {
  bool isLight = brightness == Brightness.light;
  return ChipThemeData(
    backgroundColor: isLight ? Colors.white : Colors.grey.shade800,
    disabledColor: Colors.grey,
    selectedColor: Colors.deepOrangeAccent,
    secondarySelectedColor: Colors.deepOrangeAccent,
    padding: EdgeInsets.all(4),
    labelStyle: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w600,
        color: isLight ? Colors.black : Colors.white),
    secondaryLabelStyle: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w400,
        color: isLight ? Colors.black : Colors.white),
    brightness: brightness,
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeData? _theme;
  ThemeData? get theme => _theme;

  ThemeProvider() {
    _theme = darkTheme;
    // check system theme and shared preferences
    syncTheme();
  }

  int get themeValue => _theme == lightTheme ? 0 : 1;

  syncTheme() {
    SystemChrome.setSystemUIOverlayStyle(_theme!.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark)
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.grey[900],
            systemNavigationBarIconBrightness: Brightness.light));
  }

  switchTheme(var value) {
    _theme = value == 0 ? lightTheme : darkTheme;
    notifyListeners();
    syncTheme();
  }
}
