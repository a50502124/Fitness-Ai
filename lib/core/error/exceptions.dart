class ServerException implements Exception {
  final String message;
  final String? code;

  const ServerException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  final String? code;

  const NetworkException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  final String? code;

  const ValidationException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'ValidationException: $message';
}

class CacheException implements Exception {
  final String message;
  final String? code;

  const CacheException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'CacheException: $message';
}

class PermissionException implements Exception {
  final String message;
  final String? code;

  const PermissionException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'PermissionException: $message';
}

class UnknownException implements Exception {
  final String message;
  final String? code;

  const UnknownException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'UnknownException: $message';
}
