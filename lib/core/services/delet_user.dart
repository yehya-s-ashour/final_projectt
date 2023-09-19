import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';

class DeleteUserCotroller {
  Future<bool> deleteUser({required int user_id, required String name}) async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();

    await _helper.delete(
        url: "/users/$user_id",
        body: {"name": name},
        header: {'Authorization': 'Bearer $token'});

    return true;
  }
}
