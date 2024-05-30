import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/appointment.dart';

class AppointmentServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Appointment';

  Future<List<Appointment>> get() async {
    return _getListRequest('');
  }

  Future<List<Appointment>> getAllAppointments(
      int userRoleId, int userProfileId) async {
    return _getListByFilterRequest(
        '/GetAllAppointments', userRoleId, userProfileId);
  }

  Future<Appointment> addAppointment(Appointment request) async {
    return _postRequest('', request);
  }

  Future<bool> cancelAppointment(int userRoleId, int appointmentId) async {
    return _deleteRequest('/CancelAppointment', userRoleId, appointmentId);
  }

  Future<List<Appointment>> _getListRequest(String path) async {
    var url = Uri.parse('$_baseUrl$path');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((appointmentJson) => Appointment.fromJson(appointmentJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<List<Appointment>> _getListByFilterRequest(
      String path, int userRoleId, int userProfileId) async {
    var url = Uri.parse('$_baseUrl$path/$userRoleId/$userProfileId');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((appointmentJson) => Appointment.fromJson(appointmentJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<Appointment> _postRequest(String path, Appointment request) async {
    var url = Uri.parse('$_baseUrl$path');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<bool> _deleteRequest(
      String path, int userRoleId, int appointmentId) async {
    var url = Uri.parse('$_baseUrl$path/$userRoleId/$appointmentId');
    var response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
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
