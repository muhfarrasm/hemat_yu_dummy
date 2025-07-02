import 'dart:convert';
import 'auth_data.dart'; // Pastikan AuthData didefinisikan di sini atau di file lain yang diimport

class LoginResponseModel {
  final String? status;
  final String? message;
  final AuthData? data;

  LoginResponseModel({this.status, this.message, this.data});

  /// Tambahkan ini:
  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? AuthData.fromMap(json['data']) : null,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data?.toMap(),
      };
}
