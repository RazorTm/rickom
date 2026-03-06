import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class ThemeModeChanged extends SettingsEvent {
  const ThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

class LocaleChanged extends SettingsEvent {
  const LocaleChanged(this.locale);

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
