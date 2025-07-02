class PengeluaranResponse {
  final String message;
  final Map<String, dynamic> data;

  PengeluaranResponse({
    required this.message,
    required this.data,
  });

  factory PengeluaranResponse.fromJson(Map<String, dynamic> json) {
    return PengeluaranResponse(
      message: json['message'],
      data: json['data'],
    );
  }
}
