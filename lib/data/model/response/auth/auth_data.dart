import 'dart:convert';


class AuthData {
  final User? user;
  final String? token;
  final String? tokenType;
  final int? expiresIn;

  AuthData({
    this.user,
    this.token,
    this.tokenType,
    this.expiresIn,
  });
  

  factory AuthData.fromMap(Map<String, dynamic> json) => AuthData(
        user: json["user"] != null ? User.fromMap(json["user"]) : null,
        token: json["token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "token": token,
        "token_type": tokenType,
        "expires_in": expiresIn,
      };
}

class User {
  final int? id;
  final String? username;
  final String? email;

  User({
    this.id,
    this.username,
    this.email,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
      };
}
