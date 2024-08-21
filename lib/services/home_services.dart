import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_app/models/home.dart';
import 'package:service_app/models/user_info.dart';

class HomeServices {
  final String _baseUrl = 'https://validacao.selida.com.br/core/iservice/Home';
  final storage = FlutterSecureStorage();

  Future<HomeModel> getHomeByUserId(int userId) async {
    return _getRequest('/', userId);
  }

  Future<HomeModel> _getRequest(String path, int id) async {
    print('oiii');
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path$id');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return HomeModel.fromJson(jsonDecode(response.body));
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
