import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_order/module_theme/pressistance/theme_preferences_helper.dart';

@provide
class AppThemeDataService {
  static final PublishSubject<ThemeData> _darkModeSubject =
      PublishSubject<ThemeData>();

  Stream<ThemeData> get darkModeStream => _darkModeSubject.stream;

  final ThemePreferencesHelper _preferencesHelper;

  AppThemeDataService(this._preferencesHelper);

  static Color get PrimaryColor {
    //rgb(33,150,243)
    return Color.fromRGBO(33,150,243,1);
  }

  static Color get PrimaryDarker {
    return Colors.blue[900];
  }

  static Color get AccentColor {
    return Colors.blueAccent;
  }

  Future<ThemeData> getActiveTheme() async {
    var dark = await _preferencesHelper.isDarkMode();
    if (dark == true) {
      return ThemeData(
        brightness: Brightness.dark,
        primaryColor: PrimaryColor,
        primaryColorDark: PrimaryDarker,
        accentColor: AccentColor,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          textTheme: TextTheme(),
          brightness: Brightness.dark,
          color: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      );
    }
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryDarker,
      accentColor: AccentColor,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          textTheme: TextTheme(),
          brightness: Brightness.light,
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
    );
  }

  Future<void> switchDarkMode(bool darkMode) async {
    if (darkMode) {
      await _preferencesHelper.setDarkMode();
    } else {
      await _preferencesHelper.setDayMode();
    }
    var activeTheme = await getActiveTheme();
    _darkModeSubject.add(activeTheme);
  }
}
