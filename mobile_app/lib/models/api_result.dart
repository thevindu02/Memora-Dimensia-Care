class ApiResult<T> {
  final bool success;
  final T? data;
  final String message;
  final int? statusCode;

  ApiResult({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
  });

  factory ApiResult.success(T data, {String message = 'Success'}) {
    return ApiResult<T>(success: true, data: data, message: message);
  }

  factory ApiResult.error(String message, {int? statusCode}) {
    return ApiResult<T>(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    return 'ApiResult(success: $success, message: $message, data: $data)';
  }
}
