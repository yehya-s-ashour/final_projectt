import 'dart:convert';
import 'dart:io';
import 'package:final_projectt/core/util/constants/configuration.dart';
import 'package:http/http.dart' as http;
import 'app_exception.dart';

class ApiBaseHelper {
  Future<dynamic> get(String url, Map<String, String> header) async {
    var responseJson;
    try {
      final response =
          await http.get(Uri.parse(baseUrl + url), headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, String> body,
      [Map<String, String>? header]) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(baseUrl + url),
        headers: header,
        body: body,
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(baseUrl + url),
        body: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var body = json.decode(response.body);
        var statusCode = json.decode(response.statusCode.toString());
        return [statusCode, body];
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
