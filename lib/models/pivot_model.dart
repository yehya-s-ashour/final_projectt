class Pivot {
    String tagId;
    String mailId;

    Pivot({
        required this.tagId,
        required this.mailId,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        tagId: json["tag_id"],
        mailId: json["mail_id"],
    );

    Map<String, dynamic> toJson() => {
        "tag_id": tagId,
        "mail_id": mailId,
    };
}
