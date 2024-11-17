import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_app/models/appointment.dart';
import 'package:service_app/utils/baseurlAPI.dart';

class AppointmentServices {
  final String _baseUrl = '${baseUrlAPI().APIUrl}/Appointment';
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

  Future<List<Appointment>> _getListRequest(String path) async {
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

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      var sla = jsonResponse
          .map((appointmentJson) => Appointment.fromJson(appointmentJson))
          .toList();
      return sla;
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

  Future<bool> updateAppointmentStatus(
      int appointmentId, int appointmentStatusId) async {
    return _updateStatusRequest('/', appointmentStatusId, appointmentId);
  }

  Future<bool> _updateStatusRequest(
      String path, int appointmentId, int appointmentStatusId) async {
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path/$appointmentId/$appointmentStatusId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.put(
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
