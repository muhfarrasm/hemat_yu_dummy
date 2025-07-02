class DashboardUser {
  final int id;
  final String username;
  final String email;
  final DateTime createdAt;

  DashboardUser({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class DashboardStats {
  final double totalPemasukan;
  final double totalPengeluaran;
  final double sisaSaldo;

  DashboardStats({
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.sisaSaldo,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalPemasukan: double.parse(json['total_pemasukan']),
      totalPengeluaran: double.parse(json['total_pengeluaran']),
      sisaSaldo: (json['sisa_saldo'] as num).toDouble(),
    );
  }
}

class DashboardUserResponse {
  final DashboardUser user;
  final DashboardStats stats;

  DashboardUserResponse({
    required this.user,
    required this.stats,
  });

  factory DashboardUserResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DashboardUserResponse(
      user: DashboardUser.fromJson(data['user']),
      stats: DashboardStats.fromJson(data['stats']),
    );
  }
}
