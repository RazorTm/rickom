import 'package:flutter/material.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/settings_repository.dart';

class SaveLocaleUseCase extends UseCase<void, Locale> {
  SaveLocaleUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<void>> call(Locale params) {
    return _settingsRepository.saveLocale(params);
  }
}
