import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/schedule.dart';

class ScheduleServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Schedule';

  Future<Schedule?> getByUserProfileId(int userProfileId) async {
    return _getRequest('/GetByUserProfileId', userProfileId);
  }

  Future<Schedule> save(Schedule request) async {
    return _postRequest('/Save', request);
  }

  Future<Schedule?> _getRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Schedule?.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<Schedule> _postRequest(String path, Schedule request) async {
    var url = Uri.parse('$_baseUrl$path');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Schedule.fromJson(jsonDecode(response.body));
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
