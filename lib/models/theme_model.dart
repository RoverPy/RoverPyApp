import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider extends ChangeNotifier {
  static bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  Future<void> getThemePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isDarkTheme =  pref.getBool('isDarkTheme')??false;
  }

  Future<void> setThemePreference(bool value) async {
    _isDarkTheme = value;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isDarkTheme', value);
    notifyListeners();
  }
}