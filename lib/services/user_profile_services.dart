import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/user_info.dart';
import 'package:service_app/models/user_profile.dart';

class UserProfileServices {
  final String _baseUrl = 'http://10.0.2.2:5120/UserProfile';

  Future<List<UserProfile>> getByEstablishmentCategoryId(
      int establishmentCategoryId) async {
    return _getListRequest(
        '/GetByEstablishmentCategoryId', establishmentCategoryId);
  }

  Future<List<UserProfile>> _getListRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((userProfileJson) => UserProfile.fromJson(userProfileJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<UserInfo> getById(int userId) async {
    return _getRequest('/GetUserInfoByUserId', userId);
  }

  Future<UserInfo> save(UserInfo request) async {
    return _postRequest('/Save', request);
  }

  Future<UserInfo> _getRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserInfo.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<UserInfo> _postRequest(String path, UserInfo request) async {
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
