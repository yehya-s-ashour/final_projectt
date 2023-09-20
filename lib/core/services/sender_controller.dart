import 'package:final_projectt/core/helpers/api_base_helper.dart';
import 'package:final_projectt/core/helpers/token_helper.dart';

Future<int>? deleteSender(int id) async {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final token = await getToken();
  final response = await _helper
      .delete(url: "/senders/$id", header: {'Authorization': 'Bearer $token'});
  return (response[0]);
}

Future<void> updateSender({
  int? senderId,
  String? name,
  String? mobile,
  String? categoryId,
}) async {
  final String token = await getToken();
  final ApiBaseHelper helper = ApiBaseHelper();
  final response = await helper.put(url: '/senders/$senderId', body: {
    "name": name,
    "mobile": mobile,
    "address": '',
    "category_id": categoryId,
  }, header: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  print(response);

  // return MailModel.fromJson(response[1]);
}
