// To parse this JSON data, do
//
//     final statuseses = statusesesFromJson(jsonString);

import 'dart:convert';

StatusesesModel statusesesFromJson(String str) =>
    StatusesesModel.fromJson(json.decode(str));

String statusesesToJson(StatusesesModel data) => json.encode(data.toJson());

class StatusesesModel {
  List<Status>? statuses;

  StatusesesModel({
    this.statuses,
  });

  factory StatusesesModel.fromJson(Map<String, dynamic> json) =>
      StatusesesModel(
        statuses: json["statuses"] == null
            ? []
            : List<Status>.from(
                json["statuses"]!.map((x) => Status.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toJson())),
      };
}

class Status {
  int? id;
  String? name;
  String? color;
  String? createdAt;
  String? updatedAt;
  String? mailsCount;

  Status({
    this.id,
    this.name,
    this.color,
    this.createdAt,
    this.updatedAt,
    this.mailsCount,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        mailsCount: json["mails_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "mails_count": mailsCount,
      };
}
// To parse this JSON data, do
//
//     final status = statusFromJson(jsonString);


StatusModel statusFromJson(String str) =>
    StatusModel.fromJson(json.decode(str));

String statusToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
  List<StatusElement> statuses;

  StatusModel({
    required this.statuses,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        statuses: List<StatusElement>.from(
            json["statuses"].map((x) => StatusElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statuses": List<dynamic>.from(statuses.map((x) => x.toJson())),
      };
}

class StatusElement {
  int id;
  String name;
  String color;
  String createdAt;
  String updatedAt;
  String mailsCount;

  StatusElement({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.mailsCount,
  });

  factory StatusElement.fromJson(Map<String, dynamic> json) => StatusElement(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        mailsCount: json["mails_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "mails_count": mailsCount,
      };
}
