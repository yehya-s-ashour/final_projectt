import '../../models/mail_model.dart';
import '../helpers/api_base_helper.dart';
import '../helpers/token_helper.dart';

Future<MailsModel> getMails() async {
  final ApiBaseHelper helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await helper.get(
    '/mails',
    {'Authorization': 'Bearer $token'},
  );

  return MailsModel.fromJson(response[1]);
}

Future<MailsModel> getMailsOfSingleCatego(int id) async {
  final ApiBaseHelper helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await helper.get(
    '/categories/$id/mails',
    {'Authorization': 'Bearer $token'},
  );

  return MailsModel.fromJson(response[1]);
}
