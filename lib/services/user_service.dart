import 'dart:convert';

import 'package:actu_plus/models/api_response.dart';
import 'package:actu_plus/models/constant.dart';
import 'package:actu_plus/models/user.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'accept': 'application/json'},
        body: {'email': email, 'password': password});
    print('response: $response');

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body);
        apiResponse.error = errors[errors.keys.elemetAt(0)[0]];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> register(String email, String password, String name) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'accept': 'application/json'
    }, body: {
      'email': email,
      'name': name,
      'password': password,
      'password_confirmation': password,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        print('apiResponse.data: $apiResponse.data}');
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        print('errors: $errors');
        apiResponse.error = errors[errors.keys.elementAt(0)[0]];
        break;

      default:
        apiResponse.error = somethingWentWrong;
        print('apiResponse.error: ${apiResponse.error}');
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}
