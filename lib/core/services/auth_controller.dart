import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:flutter/material.dart';

class AuthController {
  static Future<dynamic> register(
    BuildContext context, {
    required String email,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    final ApiBaseHelper helper = ApiBaseHelper();
    final response = await helper.post('/register', {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation
    });

    return (response);
  }
}
