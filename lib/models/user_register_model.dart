// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String message;
  final UserClass user;
  final String token;

  User({
    required this.message,
    required this.user,
    required this.token,
  });

  User copyWith({
    String? message,
    UserClass? user,
    String? token,
  }) =>
      User(
        message: message ?? this.message,
        user: user ?? this.user,
        token: token ?? this.token,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        message: json["message"],
        user: UserClass.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
        "token": token,
      };
}

class UserClass {
  final String name;
  final String email;
  final int roleId;
  final String updatedAt;
  final String createdAt;
  final int id;

  UserClass({
    required this.name,
    required this.email,
    required this.roleId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  UserClass copyWith({
    String? name,
    String? email,
    int? roleId,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) =>
      UserClass(
        name: name ?? this.name,
        email: email ?? this.email,
        roleId: roleId ?? this.roleId,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
      );

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        name: json["name"],
        email: json["email"],
        roleId: json["role_id"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role_id": roleId,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
