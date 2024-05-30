import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/service_category.dart';

class ServiceCategoryServices {
  final String _baseUrl = 'http://10.0.2.2:5120/ServiceCategory';

  Future<List<ServiceCategory>> getByUserProfileId(int userProfileId) async {
    return _getRequest('/GetByUserProfileId', userProfileId);
  }

  Future<ServiceCategory> addServiceCategory(ServiceCategory request) async {
    return _postRequest('', request);
  }

  Future<bool> deleteServiceCategory(int serviceCategoryId) async {
    return _deleteRequest('/SetDeleted', serviceCategoryId);
  }

  Future<List<ServiceCategory>> _getRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((serviceCategoryJson) =>
              ServiceCategory.fromJson(serviceCategoryJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<ServiceCategory> _postRequest(
      String path, ServiceCategory request) async {
    var url = Uri.parse('$_baseUrl$path');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ServiceCategory.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<bool> _deleteRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl/$id$path');
    var response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(true),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
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
