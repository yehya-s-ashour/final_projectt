import 'dart:convert';

import 'package:final_projectt/core/util/constants/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/mail_model.dart';
import '../../models/user_model.dart';
import 'package:http/http.dart' as http;

Future<List<MailElement>> getAllMails() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(allMailsUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['mails'];
    List<MailElement> mails = [];
    for (dynamic mail in data) {
      if (mail != null) {
        mails.add(MailElement.fromJson(mail));
      }
    }
    return mails;
  }

  return Future.error('Error while fetching data');
}
