import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/models/all_user_model.dart';

class AllUserController {
  Future<AllUserModel> fetchUsersData() async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();
    final response =
        await _helper.get("/users", {'Authorization': 'Bearer $token'});
    print("////**********************");
    print(response[1]);
    return AllUserModel.fromJson(response[1]);
  }
}
