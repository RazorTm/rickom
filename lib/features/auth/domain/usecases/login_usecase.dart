import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<void, LoginParams> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(LoginParams params) {
    return _authRepository.login(
      login: params.login,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  const LoginParams({required this.login, required this.password});

  final String login;
  final String password;

  @override
  List<Object?> get props => [login, password];
}
