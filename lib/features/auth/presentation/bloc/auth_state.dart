import 'package:equatable/equatable.dart';

enum AuthStatus { initial, inProgress, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.login = '',
    this.password = '',
    this.status = AuthStatus.initial,
    this.errorKey,
    this.hasAttemptedSubmit = false,
  });

  final String login;
  final String password;
  final AuthStatus status;
  final String? errorKey;
  final bool hasAttemptedSubmit;

  bool get isLoginValid => login.trim().isNotEmpty;
  bool get isPasswordValid => password.isNotEmpty;
  bool get isFormValid => isLoginValid && isPasswordValid;

  AuthState copyWith({
    String? login,
    String? password,
    AuthStatus? status,
    String? errorKey,
    bool clearErrorKey = false,
    bool? hasAttemptedSubmit,
  }) {
    return AuthState(
      login: login ?? this.login,
      password: password ?? this.password,
      status: status ?? this.status,
      errorKey: clearErrorKey ? null : (errorKey ?? this.errorKey),
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
    );
  }

  @override
  List<Object?> get props => [
    login,
    password,
    status,
    errorKey,
    hasAttemptedSubmit,
  ];
}
