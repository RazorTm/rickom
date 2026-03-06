import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_saved_locale_usecase.dart';
import '../../domain/usecases/get_saved_theme_usecase.dart';
import '../../domain/usecases/save_locale_usecase.dart';
import '../../domain/usecases/save_theme_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSavedThemeUseCase getSavedThemeUseCase,
    required SaveThemeUseCase saveThemeUseCase,
    required GetSavedLocaleUseCase getSavedLocaleUseCase,
    required SaveLocaleUseCase saveLocaleUseCase,
  }) : _getSavedThemeUseCase = getSavedThemeUseCase,
       _saveThemeUseCase = saveThemeUseCase,
       _getSavedLocaleUseCase = getSavedLocaleUseCase,
       _saveLocaleUseCase = saveLocaleUseCase,
       super(const SettingsState()) {
    on<SettingsStarted>(_onStarted);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<LocaleChanged>(_onLocaleChanged);
  }

  final GetSavedThemeUseCase _getSavedThemeUseCase;
  final SaveThemeUseCase _saveThemeUseCase;
  final GetSavedLocaleUseCase _getSavedLocaleUseCase;
  final SaveLocaleUseCase _saveLocaleUseCase;

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading, clearErrorKey: true));

    ThemeMode themeMode = ThemeMode.system;
    Locale locale = const Locale('ru');
    String? errorKey;

    final themeResult = await _getSavedThemeUseCase(const NoParams());
    themeResult.when(
      success: (value) {
        themeMode = value;
      },
      failure: (failure) {
        errorKey = failure.messageKey;
      },
    );

    final localeResult = await _getSavedLocaleUseCase(const NoParams());
    localeResult.when(
      success: (value) {
        locale = value;
      },
      failure: (failure) {
        errorKey ??= failure.messageKey;
      },
    );

    emit(
      state.copyWith(
        status: errorKey == null ? SettingsStatus.ready : SettingsStatus.error,
        themeMode: themeMode,
        locale: locale,
        errorKey: errorKey,
      ),
    );
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        themeMode: event.themeMode,
        status: SettingsStatus.ready,
        clearErrorKey: true,
      ),
    );

    final saveResult = await _saveThemeUseCase(event.themeMode);
    saveResult.when(
      success: (_) {},
      failure: (failure) {
        emit(
          state.copyWith(
            status: SettingsStatus.error,
            errorKey: failure.messageKey,
          ),
        );
      },
    );
  }

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        locale: event.locale,
        status: SettingsStatus.ready,
        clearErrorKey: true,
      ),
    );

    final saveResult = await _saveLocaleUseCase(event.locale);
    saveResult.when(
      success: (_) {},
      failure: (failure) {
        emit(
          state.copyWith(
            status: SettingsStatus.error,
            errorKey: failure.messageKey,
          ),
        );
      },
    );
  }
}
