import 'package:flutter/material.dart';

import '../../../../core/utils/result.dart';

abstract interface class SettingsRepository {
  Future<Result<ThemeMode>> getThemeMode();
  Future<Result<void>> saveThemeMode(ThemeMode themeMode);
  Future<Result<Locale>> getLocale();
  Future<Result<void>> saveLocale(Locale locale);
}
