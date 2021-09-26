import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color kBackgroundColor = Color(0xFF131313);
Color kCardColor = Color(0xFF242424);
Color kInputColor = Color(0xFF202020);
Color kSurfaceColor = Color(0xFF181818);
Color kDividerColor = Color(0xFF424242);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  toggleableActiveColor: Colors.deepOrangeAccent,
  disabledColor: Colors.grey[300],
  dividerColor: Colors.grey[300],
  chipTheme: chipTheme(Brightness.light),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  indicatorColor: Colors.deepOrangeAccent,
  iconTheme: IconThemeData(color: Colors.grey[500]),
  textSelectionTheme:
      TextSelectionThemeData(cursorColor: Colors.deepOrangeAccent),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[200],
      hintStyle: TextStyle(fontSize: 16.5, color: Colors.grey)),
  appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0.0,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey),
  sliderTheme: sliderThemeData,
  textTheme: textTheme(Brightness.light),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  pageTransitionsTheme: pageTransitionsTheme,
  colorScheme: ColorScheme(
      primary: Colors.blue,
      primaryVariant: Colors.deepPurpleAccent,
      secondary: Colors.deepOrangeAccent,
      secondaryVariant: Colors.deepOrangeAccent,
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
  toggleableActiveColor: Colors.deepOrangeAccent,
  disabledColor: kCardColor,
  dividerColor: kDividerColor,
  cardColor: kCardColor,
  chipTheme: chipTheme(Brightness.dark),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  indicatorColor: Colors.deepOrangeAccent,
  textSelectionTheme:
      TextSelectionThemeData(cursorColor: Colors.deepOrangeAccent),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: kInputColor,
      hintStyle: TextStyle(fontSize: 16.5, color: Colors.grey[400])),
  appBarTheme: AppBarTheme(color: kBackgroundColor, elevation: 0.0),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kBackgroundColor,
      elevation: 0.0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey),
  sliderTheme: sliderThemeData,
  textTheme: textTheme(Brightness.dark),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: kBackgroundColor,
  pageTransitionsTheme: pageTransitionsTheme,
  colorScheme: ColorScheme(
      primary: Colors.blue,
      primaryVariant: Colors.deepPurpleAccent,
      secondary: Colors.deepOrangeAccent,
      secondaryVariant: Colors.deepOrange,
      surface: kSurfaceColor,
      background: Colors.grey.shade900,
      error: Colors.redAccent,
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

PageTransitionsTheme pageTransitionsTheme = PageTransitionsTheme(builders: {
  TargetPlatform.android: ZoomPageTransitionsBuilder(),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
});

SliderThemeData sliderThemeData = SliderThemeData(
    trackHeight: 30,
    trackShape: CustomTrackShape(),
    valueIndicatorShape: SliderComponentShape.noThumb,
    disabledThumbColor: Colors.transparent,
    thumbShape: RoundSliderThumbShape(
        elevation: 0, pressedElevation: 0, enabledThumbRadius: 0),
    overlayColor: Colors.transparent,
    thumbColor: Colors.transparent);

class ThemeProvider extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ThemeMode get themeMode => _theme;

  late SharedPreferences prefs;

  late ThemeData theme;

  Brightness systemBrightness;

  ThemeData get systemTheme =>
      systemBrightness == Brightness.dark ? darkTheme : lightTheme;

  bool get isDark =>
      _theme == ThemeMode.dark ||
      (_theme == ThemeMode.system && systemBrightness == Brightness.dark);

  double topPadding = 0;

  int get themeValue => _theme.index;

  ThemeProvider(this.systemBrightness) {
    theme = systemTheme;
    getTheme();
  }

  getTheme() async {
    prefs = await SharedPreferences.getInstance();
    int? themePref = prefs.getInt('theme');

    if (themePref == 1) {
      _theme = ThemeMode.light;
      theme = lightTheme;
    }
    if (themePref == 2) {
      _theme = ThemeMode.dark;
      theme = darkTheme;
    }
    notifyListeners();
    syncTheme();
  }

  onSystemBrightnessChange() {
    if (_theme == ThemeMode.system) {
      theme = systemTheme;
    }
    notifyListeners();
    syncTheme();
  }

  saveTheme() async {
    await prefs.setInt('theme', themeValue);
  }

  syncTheme() {
    SystemChrome.setSystemUIOverlayStyle(!isDark
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark)
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: kBackgroundColor,
            systemNavigationBarIconBrightness: Brightness.light));
  }

  switchTheme(int value) {
    _theme = value == 0
        ? ThemeMode.system
        : value == 1
            ? ThemeMode.light
            : ThemeMode.dark;
    theme = value == 0
        ? systemTheme
        : value == 1
            ? lightTheme
            : darkTheme;

    notifyListeners();
    syncTheme();
    saveTheme();
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
