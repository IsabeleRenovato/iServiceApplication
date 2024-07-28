import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_app/models/appointment.dart';

class AppointmentServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Appointment';
  final storage = FlutterSecureStorage();

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
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Headers appointment: $headers');
    var response = await http.get(url, headers: headers);
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
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path/$userRoleId/$userProfileId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Headers appointment 2: $headers');
    var response = await http.get(url, headers: headers);
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
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Headers appointment 3: $headers');
    var response = await http.post(
      url,
      headers: headers,
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
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path/$userRoleId/$appointmentId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Headers appointment 4: $headers');
    var response = await http.delete(
      url,
      headers: headers,
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
