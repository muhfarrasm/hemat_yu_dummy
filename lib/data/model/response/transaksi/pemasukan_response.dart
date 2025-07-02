class PemasukanResponse {
  final String message;
  final Map<String, dynamic> data;

  PemasukanResponse({
    required this.message,
    required this.data,
  });

  factory PemasukanResponse.fromJson(Map<String, dynamic> json) {
    return PemasukanResponse(
      message: json['message'],
      data: json['data'],
    );
  }
}
