import 'dart:convert';
import 'auth_data.dart'; // Gunakan kelas AuthData yang sama seperti login

class RegisterResponseModel {
  final String? status;
  final String? message;
  final AuthData? data;

  RegisterResponseModel({this.status, this.message, this.data});

  /// Tambahkan ini:
  factory RegisterResponseModel.fromJson(String str) =>
      RegisterResponseModel.fromMap(json.decode(str));

  factory RegisterResponseModel.fromMap(Map<String, dynamic> json) =>
      RegisterResponseModel(
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
