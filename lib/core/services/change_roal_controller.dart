import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';

class ChangeRoleCotroller {
  Future<bool> changeRole({required int user_id, required int role_id}) async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();
    print("//////////////////////////////9999");
    print("/users/$user_id/role");
    await _helper.put(
        url: "/users/${user_id.toString()}/role",
        body: {"role_id": role_id.toString()},
        header: {'Authorization': 'Bearer $token'});

    return true;
  }
}
