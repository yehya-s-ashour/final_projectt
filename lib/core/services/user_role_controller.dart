import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/models/user_role_model.dart';

class UserRoleController {
  Future<UserRole> fetchUserRoleData() async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();
    final response =
        await _helper.get("/roles", {'Authorization': 'Bearer $token'});
    return UserRole.fromJson(response[1]);
  }
}
