import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/models/search_model.dart';

class MySearchController {
  Future<Search> fetchSearchData(String text,
      [String? start = "", String? end = "", String? status_id = ""]) async {
    final ApiBaseHelper _helper = ApiBaseHelper();
    final token = await getToken();
    final response = await _helper.get(
        "/search?text=$text&start=&end=&status_id=",
        {'Authorization': 'Bearer $token'});
    return Search.fromJson(response[1]);
  }
}
