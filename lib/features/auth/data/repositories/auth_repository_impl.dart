import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<void>> login({
    required String login,
    required String password,
  }) async {
    try {
      await _localDataSource.login(login: login, password: password);
      return const Success<void>(null);
    } on InvalidCredentialsException {
      return const FailureResult<void>(AuthFailure());
    } catch (_) {
      return const FailureResult<void>(UnknownFailure());
    }
  }
}
