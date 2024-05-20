import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/establishment_category.dart';

class EstablishmentCategoryServices {
  final String _baseUrl = 'http://10.0.2.2:5120/EstablishmentCategory';

  Future<List<EstablishmentCategory>> get() async {
    return _getRequest('');
  }

  Future<List<EstablishmentCategory>> _getRequest(String path) async {
    var url = Uri.parse('$_baseUrl$path');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
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
