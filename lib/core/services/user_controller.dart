import 'dart:convert';

import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/models/user_model.dart';

class UserController {
  Future<User> getLocalUser() async {
    SharedPrefsController prefs = SharedPrefsController();
    bool hasKey = await prefs.containsKey('user');
    if (hasKey) {
      dynamic userData = await prefs.getData('user');
      if (userData != null) {
        User user = User.fromJson(json.decode(userData));
        return user;
      }
    }
    return Future.error('not found');
  }
}
