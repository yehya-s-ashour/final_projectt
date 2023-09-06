import 'dart:convert';

import 'package:final_projectt/core/util/constants/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/catego_model.dart';
import '../../models/user_model.dart';
import 'package:http/http.dart' as http;

Future<List<CategoryElement>> getCatego() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(categoUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['categories'] as List<dynamic>;
    return data.map((e) => CategoryElement.fromJson(e)).toList();
  }

  return Future.error('Error while fetching data');
}
