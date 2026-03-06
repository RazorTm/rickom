import 'package:flutter/material.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/settings_repository.dart';

class GetSavedThemeUseCase extends UseCase<ThemeMode, NoParams> {
  GetSavedThemeUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<ThemeMode>> call(NoParams params) {
    return _settingsRepository.getThemeMode();
  }
}
