import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/special_schedule.dart';

class SpecialScheduleServices {
  final String _baseUrl = 'http://10.0.2.2:5120/SpecialSchedule';

  Future<SpecialSchedule?> getById(int specialScheduleId) async {
    return _getRequest('', specialScheduleId);
  }

  Future<List<SpecialSchedule>?> getByUserProfileId(int userProfileId) async {
    return _getListRequest('/GetByUserProfileId', userProfileId);
  }

  Future<SpecialSchedule> save(SpecialSchedule request) async {
    return _postRequest('/Save', request);
  }

  Future<bool> delete(int specialScheduleId) async {
    return _deleteRequest('/SetDeleted', specialScheduleId);
  }

  Future<SpecialSchedule?> _getRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SpecialSchedule?.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<List<SpecialSchedule>?> _getListRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((specialScheduleJson) =>
              SpecialSchedule.fromJson(specialScheduleJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<SpecialSchedule> _postRequest(
      String path, SpecialSchedule request) async {
    var url = Uri.parse('$_baseUrl$path');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SpecialSchedule.fromJson(jsonDecode(response.body));
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
