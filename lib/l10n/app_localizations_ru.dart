// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Rickom';

  @override
  String get loginTitle => 'С возвращением';

  @override
  String get loginSubtitle =>
      'Войдите, чтобы продолжить исследовать мультивселенную.';

  @override
  String get loginFieldLabel => 'Логин';

  @override
  String get loginFieldHint => 'Введите логин';

  @override
  String get passwordFieldLabel => 'Пароль';

  @override
  String get passwordFieldHint => 'Введите пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get validationRequired => 'Поле обязательно';

  @override
  String get errorEmptyFields => 'Заполните логин и пароль.';

  @override
  String get errorInvalidCredentials => 'Неверный логин или пароль.';

  @override
  String get errorNetwork =>
      'Ошибка сети. Проверьте соединение и попробуйте снова.';

  @override
  String get errorServer => 'Ошибка сервера. Попробуйте позже.';

  @override
  String get errorStorage =>
      'Не удалось сохранить настройки. Попробуйте снова.';

  @override
  String get errorUnknown => 'Что-то пошло не так.';

  @override
  String get retryButton => 'Повторить';

  @override
  String get navCharacters => 'Персонажи';

  @override
  String get navCarousel => 'Карусель';

  @override
  String get navSettings => 'Настройки';

  @override
  String get charactersListTitle => 'Персонажи';

  @override
  String get carouselScreenTitle => 'Карусель';

  @override
  String get settingsScreenTitle => 'Настройки';

  @override
  String get emptyCharacters => 'Список персонажей пуст.';

  @override
  String get carouselTitle => 'Избранные персонажи';

  @override
  String get carouselSubtitle => 'Листайте карточки героев из разных измерений';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get logoutButton => 'Выйти';
}
