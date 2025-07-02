import 'dart:convert';

class MeResponseModel {
  final String? status;
  final MeData? data;

  MeResponseModel({this.status, this.data});

  /// Tambahkan ini:
  factory MeResponseModel.fromJson(String str) =>
      MeResponseModel.fromMap(json.decode(str));

  factory MeResponseModel.fromMap(Map<String, dynamic> json) =>
      MeResponseModel(
        status: json['status'],
        data: json['data'] != null ? MeData.fromMap(json['data']) : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'data': data?.toMap(),
      };
}

class MeData {
  final User? user;
  final Stats? stats;

  MeData({this.user, this.stats});

  factory MeData.fromMap(Map<String, dynamic> json) => MeData(
        user: json['user'] != null ? User.fromMap(json['user']) : null,
        stats: json['stats'] != null ? Stats.fromMap(json['stats']) : null,
      );

  Map<String, dynamic> toMap() => {
        'user': user?.toMap(),
        'stats': stats?.toMap(),
      };
}

class User {
  final int? id;
  final String? username;
  final String? email;
  final DateTime? createdAt;

  User({this.id, this.username, this.email, this.createdAt});

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'created_at': createdAt?.toIso8601String(),
      };
}

class Stats {
  final String? totalPemasukan;
  final String? totalPengeluaran;
  final int? sisaSaldo;

  Stats({this.totalPemasukan, this.totalPengeluaran, this.sisaSaldo});

  factory Stats.fromMap(Map<String, dynamic> json) => Stats(
        totalPemasukan: json['total_pemasukan'],
        totalPengeluaran: json['total_pengeluaran'],
        sisaSaldo: json['sisa_saldo'],
      );

  Map<String, dynamic> toMap() => {
        'total_pemasukan': totalPemasukan,
        'total_pengeluaran': totalPengeluaran,
        'sisa_saldo': sisaSaldo,
      };
}
