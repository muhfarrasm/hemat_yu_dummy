import 'dart:convert';

class LoginRequestModel {
    final String? status;
    final Data? data;

    LoginRequestModel({
        this.status,
        this.data,
    });

    factory LoginRequestModel.fromJson(String str) => LoginRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LoginRequestModel.fromMap(Map<String, dynamic> json) => LoginRequestModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
    };
}

class Data {
    final User? user;
    final Stats? stats;

    Data({
        this.user,
        this.stats,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        stats: json["stats"] == null ? null : Stats.fromMap(json["stats"]),
    );

    Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "stats": stats?.toMap(),
    };
}

class Stats {
    final String? totalPemasukan;
    final String? totalPengeluaran;
    final int? sisaSaldo;

    Stats({
        this.totalPemasukan,
        this.totalPengeluaran,
        this.sisaSaldo,
    });

    factory Stats.fromJson(String str) => Stats.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Stats.fromMap(Map<String, dynamic> json) => Stats(
        totalPemasukan: json["total_pemasukan"],
        totalPengeluaran: json["total_pengeluaran"],
        sisaSaldo: json["sisa_saldo"],
    );

    Map<String, dynamic> toMap() => {
        "total_pemasukan": totalPemasukan,
        "total_pengeluaran": totalPengeluaran,
        "sisa_saldo": sisaSaldo,
    };
}

class User {
    final int? id;
    final String? username;
    final String? email;
    final DateTime? createdAt;

    User({
        this.id,
        this.username,
        this.email,
        this.createdAt,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "created_at": createdAt?.toIso8601String(),
    };
}
