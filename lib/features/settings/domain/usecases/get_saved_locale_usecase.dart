import 'package:flutter/material.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/settings_repository.dart';

class GetSavedLocaleUseCase extends UseCase<Locale, NoParams> {
  GetSavedLocaleUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<Locale>> call(NoParams params) {
    return _settingsRepository.getLocale();
  }
}
