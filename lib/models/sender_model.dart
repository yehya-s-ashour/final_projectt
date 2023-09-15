// To parse this JSON data, do
//
//     final sendersModel = sendersModelFromJson(jsonString?);

import 'dart:convert';

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

class SingleSender {
  int? id;
  String? name;
  String? mobile;
  String? address;
  String? categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? mailsCount;
  Category? category;

  SingleSender({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.mailsCount,
    required this.category,
  });

  factory SingleSender.fromJson(Map<String?, dynamic>? json) => SingleSender(
        id: json?["id"],
        name: json?["name"],
        mobile: json?["mobile"],
        address: json?["address"],
        categoryId: json?["category_id"],
        createdAt: json?["created_at"] != null
            ? DateTime.parse(json!["created_at"])
            : null,
        updatedAt: json?["updated_at"] != null
            ? DateTime.parse(json!["updated_at"])
            : null,
        mailsCount: json?["mails_count"],
        category: json?["category"] != null
            ? Category.fromJson(json!["category"])
            : null,
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "address": address,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "mails_count": mailsCount,
        "category": category?.toJson(),
      };
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
