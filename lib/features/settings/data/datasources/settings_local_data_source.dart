import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';

abstract interface class SettingsLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Locale getLocale();
  Future<void> saveLocale(Locale locale);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  ThemeMode getThemeMode() {
    final rawValue = _sharedPreferences.getString(StorageKeys.themeMode);
    switch (rawValue) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final value = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    final isSaved = await _sharedPreferences.setString(
      StorageKeys.themeMode,
      value,
    );
    if (!isSaved) {
      throw const CacheException();
    }
  }

  @override
  Locale getLocale() {
    final rawValue = _sharedPreferences.getString(StorageKeys.localeCode);
    if (rawValue == 'en') {
      return const Locale('en');
    }
    return const Locale('ru');
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final isSaved = await _sharedPreferences.setString(
      StorageKeys.localeCode,
      locale.languageCode,
    );
    if (!isSaved) {
      throw const CacheException();
    }
  }
}
