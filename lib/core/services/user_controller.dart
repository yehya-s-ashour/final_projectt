import 'dart:convert';

import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/core/util/constants/end_points.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserController {
  Future<UserModel> getLocalUser() async {
    SharedPrefsController _prefs = SharedPrefsController();
    bool hasKey = await _prefs.containsKey('user');

    if (hasKey) {
      dynamic userData = await prefs.getData('user');
      if (userData != null) {
        UserModel user = UserModel.fromJson(json.decode(userData));
        return user;
      }
    }
    return Future.error('not found');
  }

  // static Future<User> getUser() async {
  //   final ApiBaseHelper helper = ApiBaseHelper();
  //   final String token = await getToken();
  //   final response = await helper.get(
  //     '/user',
  //     {'Authorization': 'Bearer $token'},
  //   );
  //   print(User.fromJson(response[1]));
  //   return User.fromJson(response[1]);
  // }
}

// Future<String> getUserNewImage() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   User user = userFromJson(prefs.getString('user')!);
//   final response = await http.get(Uri.parse('$baseUrl/user'),
//       headers: {'Authorization': 'Bearer ${user.token}'});
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     print('the data of the user is: $data');

//     User fetchedUser = User.fromJson(data);
//     print('the fetched user is $fetchedUser');

//     return fetchedUser.user.image!;
//   }

//   throw Exception('Error while fetching user data');
// }
