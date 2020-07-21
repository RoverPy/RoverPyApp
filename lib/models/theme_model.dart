import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {

  Future<bool> getThemePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isDarkTheme')??false;
  }

  Future<void> setThemePreference(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isDarkTheme', value);
  }
}

class DarkThemeProvider extends ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  static bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    themePreference.setThemePreference(value);
    notifyListeners();
  }

}