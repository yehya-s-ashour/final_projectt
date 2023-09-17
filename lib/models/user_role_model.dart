// To parse this JSON data, do
//
//     final userRole = userRoleFromJson(jsonString);

import 'dart:convert';

UserRole userRoleFromJson(String str) => UserRole.fromJson(json.decode(str));

String userRoleToJson(UserRole data) => json.encode(data.toJson());

class UserRole {
  List<RoleElement>? roles;

  UserRole({
    this.roles,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        roles: json["roles"] == null
            ? []
            : List<RoleElement>.from(
                json["roles"]!.map((x) => RoleElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
      };
}

class RoleElement {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? usersCount;
  List<User>? users;

  RoleElement({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.usersCount,
    this.users,
  });

  factory RoleElement.fromJson(Map<String, dynamic> json) => RoleElement(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        usersCount: json["users_count"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "users_count": usersCount,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  int? id;
  String? name;
  String? email;
  String? image;
  dynamic emailVerifiedAt;
  String? roleId;
  String? createdAt;
  String? updatedAt;
  UserRoleClass? role;

  User({
    this.id,
    this.name,
    this.email,
    this.image,
    this.emailVerifiedAt,
    this.roleId,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        emailVerifiedAt: json["email_verified_at"],
        roleId: json["role_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        role:
            json["role"] == null ? null : UserRoleClass.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "email_verified_at": emailVerifiedAt,
        "role_id": roleId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "role": role?.toJson(),
      };
}

class UserRoleClass {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  UserRoleClass({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory UserRoleClass.fromJson(Map<String, dynamic> json) => UserRoleClass(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
