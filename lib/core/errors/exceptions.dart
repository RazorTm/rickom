class ServerException implements Exception {
  const ServerException([this.message = 'errorServer']);

  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'errorNetwork']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'errorStorage']);

  final String message;
}

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException([this.message = 'errorInvalidCredentials']);

  final String message;
}
