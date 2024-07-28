import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_app/models/establishment_category.dart';

class EstablishmentCategoryServices {
  final String _baseUrl = 'http://10.0.2.2:5120/EstablishmentCategory';
  final storage = FlutterSecureStorage();

  Future<List<EstablishmentCategory>> get() async {
    return _getRequest('');
  }

  Future<List<EstablishmentCategory>> _getRequest(String path) async {
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((establishmentCategoryJson) =>
              EstablishmentCategory.fromJson(establishmentCategoryJson))
          .toList();
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
