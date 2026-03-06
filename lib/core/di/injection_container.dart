import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/characters/data/datasources/characters_remote_data_source.dart';
import '../../features/characters/data/repositories/character_repository_impl.dart';
import '../../features/characters/domain/repositories/character_repository.dart';
import '../../features/characters/domain/usecases/get_characters_page_usecase.dart';
import '../../features/characters/presentation/bloc/characters_carousel_bloc.dart';
import '../../features/characters/presentation/bloc/characters_list_bloc.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_saved_locale_usecase.dart';
import '../../features/settings/domain/usecases/get_saved_theme_usecase.dart';
import '../../features/settings/domain/usecases/save_locale_usecase.dart';
import '../../features/settings/domain/usecases/save_theme_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../network/dio_client.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(DioClient.create);

  sl.registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new);
  sl.registerLazySingleton<CharactersRemoteDataSource>(
    () => CharactersRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthLocalDataSource>()),
  );
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(sl<CharactersRemoteDataSource>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => GetCharactersPageUseCase(sl<CharacterRepository>()),
  );
  sl.registerLazySingleton(
    () => GetSavedThemeUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(() => SaveThemeUseCase(sl<SettingsRepository>()));
  sl.registerLazySingleton(
    () => GetSavedLocaleUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(() => SaveLocaleUseCase(sl<SettingsRepository>()));

  sl.registerFactory(() => AuthBloc(loginUseCase: sl<LoginUseCase>()));
  sl.registerFactory(
    () => CharactersListBloc(
      getCharactersPageUseCase: sl<GetCharactersPageUseCase>(),
    ),
  );
  sl.registerFactory(
    () => CharactersCarouselBloc(
      getCharactersPageUseCase: sl<GetCharactersPageUseCase>(),
    ),
  );
  sl.registerLazySingleton(
    () => SettingsBloc(
      getSavedThemeUseCase: sl<GetSavedThemeUseCase>(),
      saveThemeUseCase: sl<SaveThemeUseCase>(),
      getSavedLocaleUseCase: sl<GetSavedLocaleUseCase>(),
      saveLocaleUseCase: sl<SaveLocaleUseCase>(),
    ),
  );
}
