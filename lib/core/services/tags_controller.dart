import 'dart:convert';

import 'package:final_projectt/core/util/constants/end_points.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import 'package:http/http.dart' as http;

Future<List<TagElement>> getAllTags() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(allTagsUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['tags'] as List<dynamic>;
    return data.map((e) => TagElement.fromJson(e)).toList();
  }

  return Future.error('Error while fetching Tags data');
}
Future<List<Mails>> getAllMailsHaveTags(List<int> listOfTagsId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse('$baseUrl/tags?tags=$listOfTagsId'),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['tags'] as List<dynamic>;

    List<Mails> allMails = [];

    for (var tagData in data) {
      final mails = (tagData['mails'] as List<dynamic>)
          .map((mail) => Mails.fromJson(mail))
          .toList();
      allMails.addAll(mails);
    }

    return allMails;
  }

  throw Exception('Error while fetching Mails data');
}
