import '../../../../core/errors/exceptions.dart';

abstract interface class AuthLocalDataSource {
  Future<void> login({required String login, required String password});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> login({required String login, required String password}) async {
    if (login == 'rick' && password == 'morty') {
      return;
    }
    throw const InvalidCredentialsException();
  }
}
