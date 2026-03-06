// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rickom';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue exploring the multiverse.';

  @override
  String get loginFieldLabel => 'Login';

  @override
  String get loginFieldHint => 'Enter your login';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get passwordFieldHint => 'Enter your password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get errorEmptyFields => 'Please fill in both login and password.';

  @override
  String get errorInvalidCredentials => 'Invalid login or password.';

  @override
  String get errorNetwork =>
      'Network error. Check your connection and try again.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorStorage => 'Could not save settings. Try again.';

  @override
  String get errorUnknown => 'Something went wrong.';

  @override
  String get retryButton => 'Retry';

  @override
  String get navCharacters => 'Characters';

  @override
  String get navCarousel => 'Carousel';

  @override
  String get navSettings => 'Settings';

  @override
  String get charactersListTitle => 'Characters';

  @override
  String get carouselScreenTitle => 'Carousel';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get emptyCharacters => 'No characters found.';

  @override
  String get carouselTitle => 'Featured characters';

  @override
  String get carouselSubtitle => 'Swipe through your cross-dimensional picks';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Russian';

  @override
  String get logoutButton => 'Logout';
}
