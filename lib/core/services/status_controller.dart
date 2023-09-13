import 'package:final_projectt/core/helpers/api_base_helper.dart';
//import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:final_projectt/models/status_single.dart';

class StatusController {
  Future<StatusesesModel> fetchStatuse() async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();
    final response = await _helper
        .get("/statuses?mail=false", {'Authorization': 'Bearer $token'});
    return StatusesesModel.fromJson(response[1]);
  }

  Future<StatusSingle> fetchSingleStatuse(int typeStatus) async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();
    final response = await _helper.get(
        "/statuses/$typeStatus?mail=true", {'Authorization': 'Bearer $token'});
    return StatusSingle.fromJson(response[1]);
  }
}
