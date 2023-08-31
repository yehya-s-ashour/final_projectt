import 'dart:convert';

import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/models/user_model.dart';

class UserController {
  Future<User> getLocalUser() async {
    SharedPrefsController _prefs = SharedPrefsController();
    bool hasKey = await _prefs.containsKey('user');
    if (hasKey) {
      dynamic userData = await _prefs.getData('user');
      if (userData != null) {
        User user = User.fromJson(json.decode(userData));
        return user;
      }
    }
    return Future.error('not found');
  }
}
