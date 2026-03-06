import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginChanged extends AuthEvent {
  const AuthLoginChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class AuthPasswordChanged extends AuthEvent {
  const AuthPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class AuthSubmitted extends AuthEvent {
  const AuthSubmitted();
}
