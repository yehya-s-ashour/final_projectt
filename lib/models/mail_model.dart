// To parse this JSON data, do
//
//     final mailsModel = mailsModelFromJson(jsonString);

import 'dart:convert';

MailsModel mailsModelFromJson(String str) =>
    MailsModel.fromJson(json.decode(str));

String mailsModelToJson(MailsModel data) => json.encode(data.toJson());

class MailsModel {
  final List<Mail> mails;

  MailsModel({
    required this.mails,
  });

  MailsModel copyWith({
    List<Mail>? mails,
  }) =>
      MailsModel(
        mails: mails ?? this.mails,
      );

  factory MailsModel.fromJson(Map<String, dynamic> json) => MailsModel(
        mails: List<Mail>.from(json["mails"].map((x) => Mail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mails": List<dynamic>.from(mails.map((x) => x.toJson())),
      };
}

class Mail {
  final int id;
  final String subject;
  final String? description;
  final String senderId;
  final String archiveNumber;
  final String archiveDate;
  final String? decision;
  final String statusId;
  final String? finalDecision;
  final String createdAt;
  final String updatedAt;
  final Sender? sender;
  final SingleStatus? status;
  final List<Attachment> attachments;
  final List<Activity> activities;
  final List<Tag> tags;

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
    required this.sender,
    required this.status,
    required this.attachments,
    required this.activities,
    required this.tags,
  });

  Mail copyWith({
    int? id,
    String? subject,
    String? description,
    String? senderId,
    String? archiveNumber,
    String? archiveDate,
    String? decision,
    String? statusId,
    String? finalDecision,
    String? createdAt,
    String? updatedAt,
    Sender? sender,
    SingleStatus? status,
    List<Attachment>? attachments,
    List<Activity>? activities,
    List<Tag>? tags,
  }) =>
      Mail(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        description: description ?? this.description,
        senderId: senderId ?? this.senderId,
        archiveNumber: archiveNumber ?? this.archiveNumber,
        archiveDate: archiveDate ?? this.archiveDate,
        decision: decision ?? this.decision,
        statusId: statusId ?? this.statusId,
        finalDecision: finalDecision ?? this.finalDecision,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sender: sender ?? this.sender,
        status: status ?? this.status,
        attachments: attachments ?? this.attachments,
        activities: activities ?? this.activities,
        tags: tags ?? this.tags,
      );

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
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        status: json["status"] == null
            ? null
            : SingleStatus.fromJson(json["status"]),
        attachments: List<Attachment>.from(
            json["attachments"].map((x) => Attachment.fromJson(x))),
        activities: List<Activity>.from(
            json["activities"].map((x) => Activity.fromJson(x))),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
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
        "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
      };
}

class Activity {
  final int id;
  final String body;
  final String userId;
  final String mailId;
  final String? sendNumber;
  final dynamic sendDate;
  final dynamic sendDestination;
  final String createdAt;
  final String updatedAt;
  final User user;

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

  Activity copyWith({
    int? id,
    String? body,
    String? userId,
    String? mailId,
    String? sendNumber,
    dynamic sendDate,
    dynamic sendDestination,
    String? createdAt,
    String? updatedAt,
    User? user,
  }) =>
      Activity(
        id: id ?? this.id,
        body: body ?? this.body,
        userId: userId ?? this.userId,
        mailId: mailId ?? this.mailId,
        sendNumber: sendNumber ?? this.sendNumber,
        sendDate: sendDate ?? this.sendDate,
        sendDestination: sendDestination ?? this.sendDestination,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

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

class User {
  final int id;
  final String name;
  final String email;
  final String? image;
  final String? emailVerifiedAt;
  final String roleId;
  final String? createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.emailVerifiedAt,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? image,
    String? emailVerifiedAt,
    String? roleId,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        image: image ?? this.image,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        roleId: roleId ?? this.roleId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        emailVerifiedAt: json["email_verified_at"],
        roleId: json["role_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
      };
}

class Attachment {
  final int id;
  final String title;
  final String image;
  final String mailId;
  final String createdAt;
  final String updatedAt;

  Attachment({
    required this.id,
    required this.title,
    required this.image,
    required this.mailId,
    required this.createdAt,
    required this.updatedAt,
  });

  Attachment copyWith({
    int? id,
    String? title,
    String? image,
    String? mailId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Attachment(
        id: id ?? this.id,
        title: title ?? this.title,
        image: image ?? this.image,
        mailId: mailId ?? this.mailId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

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

class Sender {
  final int id;
  final String name;
  final String mobile;
  final String? address;
  final String categoryId;
  final String createdAt;
  final String updatedAt;
  final Tag category;

  Sender({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  Sender copyWith({
    int? id,
    String? name,
    String? mobile,
    String? address,
    String? categoryId,
    String? createdAt,
    String? updatedAt,
    Tag? category,
  }) =>
      Sender(
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        address: address ?? this.address,
        categoryId: categoryId ?? this.categoryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        category: category ?? this.category,
      );

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        address: json["address"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        category: Tag.fromJson(json["category"]),
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

class Tag {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final Pivot? pivot;

  Tag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.pivot,
  });

  Tag copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
    Pivot? pivot,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        pivot: pivot ?? this.pivot,
      );

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
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

class Pivot {
  final String mailId;
  final String tagId;

  Pivot({
    required this.mailId,
    required this.tagId,
  });

  Pivot copyWith({
    String? mailId,
    String? tagId,
  }) =>
      Pivot(
        mailId: mailId ?? this.mailId,
        tagId: tagId ?? this.tagId,
      );

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        mailId: json["mail_id"],
        tagId: json["tag_id"],
      );

  Map<String, dynamic> toJson() => {
        "mail_id": mailId,
        "tag_id": tagId,
      };
}

class SingleStatus {
  final int id;
  final String name;
  final String color;

  SingleStatus({
    required this.id,
    required this.name,
    required this.color,
  });

  SingleStatus copyWith({
    int? id,
    String? name,
    String? color,
  }) =>
      SingleStatus(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );

  factory SingleStatus.fromJson(Map<String, dynamic> json) => SingleStatus(
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
