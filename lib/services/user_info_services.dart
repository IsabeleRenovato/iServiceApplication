import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_app/models/user_info.dart';
import 'package:service_app/utils/baseurlAPI.dart';

class UserInfoServices {
  final String _baseUrl = '${baseUrlAPI().APIUrl}/UserInfo';
  final storage = FlutterSecureStorage();

  Future<UserInfo> getUserInfoByUserId(int userId) async {
    return _getRequest('/GetUserInfoByUserId', userId);
  }

  Future<UserInfo> _getRequest(String path, int id) async {
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path/$id');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
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
