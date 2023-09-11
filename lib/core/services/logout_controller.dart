import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:flutter/material.dart';

Future<dynamic> logout(
  BuildContext context,
) async {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final response = await _helper
      .post('/logout', {}, {'Authorization': 'Bearer ${await getToken()}'});

  return (response);
}
