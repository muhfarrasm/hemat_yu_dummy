class DashboardMeResponse {
  final String username;
  final int sisaSaldo;

  DashboardMeResponse({
    required this.username,
    required this.sisaSaldo,
  });

  factory DashboardMeResponse.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'];
    final stats = json['data']['stats'];

    return DashboardMeResponse(
      username: user['username'] ?? '',
      sisaSaldo: stats['sisa_saldo'] ?? 0,
    );
  }
}

class TotalPemasukanResponse {
  final int total;
  final int month;
  final int year;

  TotalPemasukanResponse({
    required this.total,
    required this.month,
    required this.year,
  });

  factory TotalPemasukanResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return TotalPemasukanResponse(
      total: data['total'] ?? 0,
      month: data['month'] ?? 0,
      year: data['year'] ?? 0,
    );
  }
}
