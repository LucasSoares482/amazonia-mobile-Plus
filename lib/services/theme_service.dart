import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  static const _key = 'theme_mode';
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);
  final ValueNotifier<bool> isTransitioning = ValueNotifier(false);
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    final stored = _prefs?.getString(_key);
    themeMode.value = _stringToThemeMode(stored);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    isTransitioning.value = true;
    themeMode.value = mode;
    await _prefs?.setString(_key, _themeModeToString(mode));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    isTransitioning.value = false;
  }

  Future<void> toggleDarkMode(bool isDark) =>
      setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
    return 'system';
  }

  ThemeMode _stringToThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
