import '../../../../core/utils/result.dart';

abstract interface class AuthRepository {
  Future<Result<void>> login({required String login, required String password});
}
