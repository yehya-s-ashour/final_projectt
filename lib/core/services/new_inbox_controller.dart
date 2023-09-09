import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:final_projectt/models/tags_model.dart';

Future<Senders> getSenders() async {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await _helper.get(
    '/senders?mail=false',
    {'Authorization': 'Bearer $token'},
  );
  return SendersModel.fromJson(response[1]).senders;
}

Future<Tag> getTags() async {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await _helper.get(
    '/tags',
    {'Authorization': 'Bearer $token'},
  );
  print(Tag.fromJson(response[1]));
  return Tag.fromJson(response[1]);
}

Future<void> createTag(String tagName) async {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await _helper.post(
    '/tags',
    {'name': tagName},
    {'Authorization': 'Bearer $token'},
  );
}

Future<void> createMail({
  required String subject,
  required String archiveNumber,
  required String archiveDate,
  required String statusId,
  String? description,
  String? senderId,
  String? decision,
  String? finalDecision,
  List<int>? tags,
  List<Map<String, dynamic>>? activities,
}) async {
  final String token = await getToken();
  final response =
      await http.post(Uri.parse('https://palmail.gsgtt.tech/api/mails'), body: {
    "subject": subject,
    "description": description,
    "sender_id": senderId,
    "archive_number": archiveNumber,
    "archive_date": archiveDate,
    "decision": decision,
    "status_id": statusId,
    "final_decision": finalDecision,
    "tags": jsonEncode(tags),
    "activities": jsonEncode(activities),
  }, headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });
  print(token);
  print(response.body);
  // return Mail.fromMap(response['mail']);
}
