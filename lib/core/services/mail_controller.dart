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

// Future<MailsModel> getMailsOfSingleCatego(int id) async {
//   final ApiBaseHelper helper = ApiBaseHelper();
//   final String token = await getToken();
//   final response = await helper.get(
//     '/categories/$id/mails',
//     {'Authorization': 'Bearer $token'},
//   );

//   return MailsModel.fromJson(response[1]);
// }

Future<MailsModel> getMailsOfSingleCatego(int id) async {
  final ApiBaseHelper helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await helper.get(
    '/mails',
    {'Authorization': 'Bearer $token'},
  );
  MailsModel mainModel = MailsModel.fromJson(response[1]);
  List<Mail> filterdMails = [];
  for (Mail mail in mainModel.mails!.toList()) {
    int categoryId = mail.sender?.category?.id ?? -1;
    if (categoryId == id) {
      filterdMails.add(mail);
    }
  }
  return MailsModel(mails: filterdMails);
}

Future<void>? deleteMail(String id) async {
  final ApiBaseHelper helper = ApiBaseHelper();
  final String token = await getToken();
  final response = await helper.delete(
    '/mails/$id',
    {'Authorization': 'Bearer $token'},
  );

  print(response);
}
