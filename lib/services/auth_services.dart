import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/auth/pre_register.dart';
import 'package:service_app/models/auth/login.dart';
import 'package:service_app/models/user_info.dart';

class AuthServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Auth/';

  Future<UserInfo> preRegister(PreRegister request) async {
    return _postRequest('preregister', request);
  }

  Future<UserInfo> registerUserProfile(UserInfo request) async {
    return _postRequest('RegisterUserProfile', request);
  }

  Future<UserInfo> registerAddress(UserInfo request) async {
    return _postRequest('RegisterAddress', request);
  }

  Future<UserInfo> login(Login request) async {
    return _postRequest('login', request);
  }

  Future<UserInfo> _postRequest(String path, dynamic request) async {
    var url = Uri.parse('$_baseUrl$path');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserInfo.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Exception _handleError(String responseBody) {
    var jsonResponse = jsonDecode(responseBody);
    var errorMessage = jsonResponse['message'] ?? 'Erro desconhecido';
    throw Exception(errorMessage);
  }
}
