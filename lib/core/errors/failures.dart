import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.messageKey);

  final String messageKey;

  @override
  List<Object> get props => [messageKey];
}

class ServerFailure extends Failure {
  const ServerFailure([super.messageKey = 'errorServer']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.messageKey = 'errorNetwork']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.messageKey = 'errorStorage']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.messageKey = 'errorEmptyFields']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.messageKey = 'errorInvalidCredentials']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.messageKey = 'errorUnknown']);
}
