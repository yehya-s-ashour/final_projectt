// To parse this JSON data, do
//
//     final mail = mailFromJson(jsonString);

import 'dart:convert';

import 'package:final_projectt/models/pivot_model.dart';
import 'package:final_projectt/models/user_model.dart';

Mail mailFromJson(String str) => Mail.fromJson(json.decode(str));

String mailToJson(Mail data) => json.encode(data.toJson());

class Mail {
  List<MailElement> mails;

  Mail({
    required this.mails,
  });

  factory Mail.fromJson(Map<String, dynamic> json) => Mail(
        mails: List<MailElement>.from(
            json["mails"].map((x) => MailElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mails": List<dynamic>.from(mails.map((x) => x.toJson())),
      };
}

class MailElement {
  int? id;
  String? subject;
  String? description;
  String? senderId;
  String? archiveNumber;
  String? archiveDate;
  String? decision;
  String? statusId;
  String? finalDecision;
  String? createdAt;
  String? updatedAt;
  SenderInMail? sender;
  MailStatus? status;
  List<TagInMail>? tags;
  List<Attachment>? attachments;
  List<Activity>? activities;

  MailElement({
      this.id,
      this.subject,
      this.description,
      this.senderId,
      this.archiveNumber,
      this.archiveDate,
      this.decision,
      this.statusId,
      this.finalDecision,
      this.createdAt,
      this.updatedAt,
      this.sender,
      this.status,
      this.tags,
      this.attachments,
      this.activities,
  });

  factory MailElement.fromJson(Map<String, dynamic> json) => MailElement(
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
        sender:  json['sender'] != null ? SenderInMail.fromJson(json['sender']) : null, 
        status: json['status'] != null ?  MailStatus.fromJson(json["status"]) : null ,
        tags: json['tags'] != null ? List<TagInMail>.from(
            json["tags"].map((x) => TagInMail.fromJson(x))): null,
        attachments: json['attachments']!= null ? List<Attachment>.from(
            json["attachments"].map((x) => Attachment.fromJson(x))):null,
        activities: json['activities']!= null ? List<Activity>.from(
            json["activities"].map((x) => Activity.fromJson(x))) : null ,
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
        "sender": sender?.toJson(),
        "status": status?.toJson(),
        "tags": List<dynamic>.from(tags!.map((x) => x.toJson())),
        "attachments": List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "activities": List<dynamic>.from(activities!.map((x) => x.toJson())),
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

class Attachment {
  int id;
  String title;
  String image;
  String mailId;
  String createdAt;
  String updatedAt;

  Attachment({
    required this.id,
    required this.title,
    required this.image,
    required this.mailId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        mailId: json["mail_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "mail_id": mailId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class SenderInMail {
  int id;
  String name;
  String mobile;
  String? address;
  String categoryId;
  String createdAt;
  String updatedAt;
  CategoryInMail category;

  SenderInMail({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory SenderInMail.fromJson(Map<String, dynamic> json) => SenderInMail(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        address: json["address"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        category: CategoryInMail.fromJson(json["category"]),
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

class TagInMail {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  Pivot? pivot;

  TagInMail({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.pivot,
  });

  factory TagInMail.fromJson(Map<String, dynamic> json) => TagInMail(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pivot": pivot?.toJson(),
      };
}

class CategoryInMail {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  CategoryInMail({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryInMail.fromJson(Map<String, dynamic> json) => CategoryInMail(
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

 

class MailStatus {
  int id;
  String name;
  String color;

  MailStatus({
    required this.id,
    required this.name,
    required this.color,
  });

  factory MailStatus.fromJson(Map<String, dynamic> json) => MailStatus(
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
