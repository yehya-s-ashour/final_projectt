// To parse this JSON data, do
//
//     final sendersModel = sendersModelFromJson(jsonString?);

import 'dart:convert';

import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:final_projectt/models/tags_model.dart';

SendersModel sendersModelFromJson(String? str) =>
    SendersModel.fromJson(json.decode(str ?? "{}"));

String? sendersModelToJson(SendersModel data) => json.encode(data.toJson());

class SendersModel {
  Senders? senders;

  SendersModel({
    required this.senders,
  });

  factory SendersModel.fromJson(Map<String?, dynamic>? json) => SendersModel(
        senders: json != null ? Senders.fromJson(json["senders"]) : null,
      );

  Map<String?, dynamic> toJson() => {
        "senders": senders?.toJson(),
      };
}

class Senders {
  int? currentPage;
  List<SingleSender>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Senders({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Senders.fromJson(Map<String?, dynamic>? json) => Senders(
        currentPage: json?["current_page"],
        data: json?["data"] != null
            ? List<SingleSender>.from(
                (json!["data"] as List).map((x) => SingleSender.fromJson(x)))
            : null,
        firstPageUrl: json?["first_page_url"],
        from: json?["from"],
        lastPage: json?["last_page"],
        lastPageUrl: json?["last_page_url"],
        links: json?["links"] != null
            ? List<Link>.from(
                (json!["links"] as List).map((x) => Link.fromJson(x)))
            : null,
        nextPageUrl: json?["next_page_url"],
        path: json?["path"],
        perPage: json?["per_page"],
        prevPageUrl: json?["prev_page_url"],
        to: json?["to"],
        total: json?["total"],
      );

  Map<String?, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : null,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links != null
            ? List<dynamic>.from(links!.map((x) => x.toJson()))
            : null,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class NewSender {
  String? message;
  List<SingleSender>? singleSender;

  NewSender({this.message, this.singleSender});

  NewSender.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['sender'] != null) {
      singleSender = <SingleSender>[];
      json['sender'].forEach((v) {
        singleSender!.add(new SingleSender.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.singleSender != null) {
      data['singleSender'] = this.singleSender!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SingleSender {
  int? id;
  String? name;
  String? mobile;
  String? address;
  String? categoryId;
  String? createdAt;
  String? updatedAt;
  String? mailsCount;
  Category? category;
  List<SenderMail>? mails;

  SingleSender(
      {this.id,
      this.name,
      this.mobile,
      this.address,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.mailsCount,
      this.category,
      this.mails});

  SingleSender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    address = json['address'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mailsCount = json['mails_count'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['mails'] != null) {
      mails = <SenderMail>[];
      json['mails'].forEach((v) {
        mails!.add(new SenderMail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mails_count'] = this.mailsCount;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.mails != null) {
      data['mails'] = this.mails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SenderMail {
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
  Sender? sender;
  SingleStatus? status;
  List<Attachments>? attachments;
  List<Activities>? activities;
  List<TagElement>? tags;

  SenderMail(
      {this.id,
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
      this.attachments,
      this.activities,
      this.tags});

  SenderMail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    description = json['description'];
    senderId = json['sender_id'];
    archiveNumber = json['archive_number'];
    archiveDate = json['archive_date'];
    decision = json['decision'];
    statusId = json['status_id'];
    finalDecision = json['final_decision'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    status = json['status'] != null
        ? new SingleStatus.fromJson(json['status'])
        : null;
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
    if (json['activities'] != null) {
      activities = <Activities>[];
      json['activities'].forEach((v) {
        activities!.add(new Activities.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <TagElement>[];
      json['tags'].forEach((v) {
        tags!.add(new TagElement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['sender_id'] = this.senderId;
    data['archive_number'] = this.archiveNumber;
    data['archive_date'] = this.archiveDate;
    data['decision'] = this.decision;
    data['status_id'] = this.statusId;
    data['final_decision'] = this.finalDecision;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    if (this.activities != null) {
      data['activities'] = this.activities!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String?, dynamic>? json) => Category(
        id: json?["id"],
        name: json?["name"],
        createdAt: json?["created_at"] != null
            ? DateTime.parse(json!["created_at"])
            : null,
        updatedAt: json?["updated_at"] != null
            ? DateTime.parse(json!["updated_at"])
            : null,
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String?, dynamic>? json) => Link(
        url: json?["url"],
        label: json?["label"],
        active: json?["active"],
      );

  Map<String?, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
