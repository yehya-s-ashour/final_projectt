// To parse this JSON data, do
//
//     final tag = tagFromJson(jsonString);

import 'dart:convert';

import 'package:final_projectt/models/pivot_model.dart';

import 'package:final_projectt/models/user_model.dart';

Tag tagFromJson(String str) => Tag.fromJson(json.decode(str));

String tagToJson(Tag data) => json.encode(data.toJson());

class Tag {
  List<TagElement> tags;

  Tag({
    required this.tags,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tags: List<TagElement>.from(
            json["tags"].map((x) => TagElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
      };
}

class SenderInTags {
  int id;
  String name;
  String mobile;
  String? address;
  String categoryId;
  String createdAt;
  String updatedAt;
  TagElement category;

  SenderInTags({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory SenderInTags.fromJson(Map<String, dynamic> json) => SenderInTags(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        address: json["address"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        category: TagElement.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "address": address,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category": category.toJson(),
      };
}

class Mail {
  int id;
  String subject;
  String? description;
  String senderId;
  String archiveNumber;
  String archiveDate;
  String? decision;
  String statusId;
  dynamic finalDecision;
  String createdAt;
  String updatedAt;
  Pivot pivot;
  SenderInTags sender;
  TagsStatus status;
  List<TagElement> tags;
  List<dynamic> attachments;
  List<Activity> activities;

  Mail({
    required this.id,
    required this.subject,
    required this.description,
    required this.senderId,
    required this.archiveNumber,
    required this.archiveDate,
    required this.decision,
    required this.statusId,
    required this.finalDecision,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
    required this.sender,
    required this.status,
    required this.tags,
    required this.attachments,
    required this.activities,
  });

  factory Mail.fromJson(Map<String, dynamic> json) => Mail(
        id: json["id"],
        subject: json["subject"],
        description: json["description"],
        senderId: json["sender_id"],
        archiveNumber: json["archive_number"],
        archiveDate: json["archive_date"],
        decision: json["decision"],
        statusId: json["status_id"],
        finalDecision: json["final_decision"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pivot: Pivot.fromJson(json["pivot"]),
        sender: SenderInTags.fromJson(json["sender"]),
        status: TagsStatus.fromJson(json["status"]),
        tags: List<TagElement>.from(
            json["tags"].map((x) => TagElement.fromJson(x))),
        attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
        activities: List<Activity>.from(
            json["activities"].map((x) => Activity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "description": description,
        "sender_id": senderId,
        "archive_number": archiveNumber,
        "archive_date": archiveDate,
        "decision": decision,
        "status_id": statusId,
        "final_decision": finalDecision,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pivot": pivot.toJson(),
        "sender": sender.toJson(),
        "status": status.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "attachments": List<dynamic>.from(attachments.map((x) => x)),
        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
      };
}

class TagElement {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  List<Mail>? mails;
  Pivot? pivot;

  TagElement({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.mails,
    this.pivot,
  });

  factory TagElement.fromJson(Map<String, dynamic> json) => TagElement(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        mails: json["mails"] == null
            ? []
            : List<Mail>.from(json["mails"]!.map((x) => Mail.fromJson(x))),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "mails": mails == null
            ? []
            : List<dynamic>.from(mails!.map((x) => x.toJson())),
        "pivot": pivot?.toJson(),
      };
}

class Activity {
  int id;
  String body;
  String userId;
  String mailId;
  dynamic sendNumber;
  dynamic sendDate;
  dynamic sendDestination;
  String createdAt;
  String updatedAt;
  User user;

  Activity({
    required this.id,
    required this.body,
    required this.userId,
    required this.mailId,
    required this.sendNumber,
    required this.sendDate,
    required this.sendDestination,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        body: json["body"],
        userId: json["user_id"],
        mailId: json["mail_id"],
        sendNumber: json["send_number"],
        sendDate: json["send_date"],
        sendDestination: json["send_destination"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "user_id": userId,
        "mail_id": mailId,
        "send_number": sendNumber,
        "send_date": sendDate,
        "send_destination": sendDestination,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user.toJson(),
      };
}

class TagsStatus {
  int id;
  String name;
  String color;

  TagsStatus({
    required this.id,
    required this.name,
    required this.color,
  });

  factory TagsStatus.fromJson(Map<String, dynamic> json) => TagsStatus(
        id: json["id"],
        name: json["name"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
      };
}
