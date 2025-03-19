class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  ApiResponse(this.success, this.data, this.errorMessage);

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(json['success'], json['data'], json['errorMessage']);
  }

  factory ApiResponse.fromError(String errorMessage) {
    return ApiResponse(false, null, errorMessage);
  }
}
