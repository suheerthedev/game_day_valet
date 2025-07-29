class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

class NoInternetException extends ApiException {
  NoInternetException() : super("No Internet Connection.");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super("Unauthorized Access.", 401);
}
