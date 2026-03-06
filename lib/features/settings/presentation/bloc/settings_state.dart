import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SettingsStatus { initial, loading, ready, error }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('ru'),
    this.errorKey,
  });

  final SettingsStatus status;
  final ThemeMode themeMode;
  final Locale locale;
  final String? errorKey;

  SettingsState copyWith({
    SettingsStatus? status,
    ThemeMode? themeMode,
    Locale? locale,
    String? errorKey,
    bool clearErrorKey = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      errorKey: clearErrorKey ? null : (errorKey ?? this.errorKey),
    );
  }

  @override
  List<Object?> get props => [status, themeMode, locale, errorKey];
}
