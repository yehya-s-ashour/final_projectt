import 'dart:convert';
import 'dart:io';
import 'package:final_projectt/core/util/constants/end_points.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<MailModel> newInbox({
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
  final ApiBaseHelper _helper = ApiBaseHelper();
  final response = await _helper.post('/mails', {
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
  }, {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  return MailModel.fromJson(response[1]);
}

Future<List<TagElement>> getAllTags() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse('$baseUrl/tags'),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['tags'] as List<dynamic>;
    return data.map((e) => TagElement.fromJson(e)).toList();
  }

  return Future.error('Error while fetching Tags data');
}

Future<int> uploadImage(File file, mailId) async {
  String token = await getToken();
  var request =
      http.MultipartRequest("POST", Uri.parse('$baseUrl/attachments'));
  var pic = await http.MultipartFile.fromPath('image', file.path);
  request.fields['mail_id'] = mailId.toString();
  request.fields['title'] = 'image_${DateTime.now()}';
  request.files.add(pic);
  request.headers
      .addAll({'Accept': 'application/json', 'Authorization': 'Bearer $token'});
  var response = await request.send();

  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  debugPrint(responseString);
  return response.statusCode;
}

uploadImages(BuildContext context, int mailId) {
  final imagesProvider =
      Provider.of<NewInboxProvider>(context, listen: false).imagesFiles;
  for (int i = 0; i < imagesProvider.length; i++) {
    uploadImage(File(imagesProvider[i]!.path), mailId);
  }
}


// Future<void> uploadImages(BuildContext context, int mailId) async {
//   final token = await getToken();
//   final imagesProvider = Provider.of<NewInboxProvider>(context, listen: false);

//   for (final xFile in imagesProvider.imagesFiles) {
//     if (xFile != null) {
//       final request =
//           http.MultipartRequest("POST", Uri.parse('$baseUrl/attachments'));
//       final file = File(xFile.path);
//       final pic = await http.MultipartFile.fromPath('image', file.path);
//       request.fields['mail_id'] = mailId.toString();
//       request.fields['title'] = 'image_${DateTime.now()}';
//       request.files.add(pic);
//       request.headers.addAll(
//           {'Accept': 'application/json', 'Authorization': 'Bearer $token'});

//       final response = await request.send();
//       final responseData = await response.stream.toBytes();
//       final responseString = String.fromCharCodes(responseData);
//       print(responseString);
//     }
//   }
// }
