import 'package:flutter/material.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/settings_repository.dart';

class SaveThemeUseCase extends UseCase<void, ThemeMode> {
  SaveThemeUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<void>> call(ThemeMode params) {
    return _settingsRepository.saveThemeMode(params);
  }
}
