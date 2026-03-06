import 'package:flutter/material.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<Result<ThemeMode>> getThemeMode() async {
    try {
      final themeMode = _localDataSource.getThemeMode();
      return Success(themeMode);
    } on CacheException {
      return const FailureResult<ThemeMode>(CacheFailure());
    } catch (_) {
      return const FailureResult<ThemeMode>(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> saveThemeMode(ThemeMode themeMode) async {
    try {
      await _localDataSource.saveThemeMode(themeMode);
      return const Success<void>(null);
    } on CacheException {
      return const FailureResult<void>(CacheFailure());
    } catch (_) {
      return const FailureResult<void>(UnknownFailure());
    }
  }

  @override
  Future<Result<Locale>> getLocale() async {
    try {
      final locale = _localDataSource.getLocale();
      return Success(locale);
    } on CacheException {
      return const FailureResult<Locale>(CacheFailure());
    } catch (_) {
      return const FailureResult<Locale>(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> saveLocale(Locale locale) async {
    try {
      await _localDataSource.saveLocale(locale);
      return const Success<void>(null);
    } on CacheException {
      return const FailureResult<void>(CacheFailure());
    } catch (_) {
      return const FailureResult<void>(UnknownFailure());
    }
  }
}
