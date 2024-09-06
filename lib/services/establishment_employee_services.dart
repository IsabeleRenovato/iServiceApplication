import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/establishment_employee.dart';

import 'package:service_app/utils/baseurlAPI.dart';

class EstablishmentEmployeeServices {
  final String _baseUrl = '${baseUrlAPI().APIUrl}/EstablishmentEmployee';
  final storage = FlutterSecureStorage();

  Future<EstablishmentEmployee?> getById(int establishmentEmployeeId) async {
    return _getRequest('', establishmentEmployeeId);
  }

  Future<List<EstablishmentEmployee?>> getEmployeeByUserProfileId() async {
    return _getListRequest('/');
  }

  Future<EstablishmentEmployee> addEstablishmentEmployee(
      EstablishmentEmployee request) async {
    return _postRequest('', request);
  }

  Future<EstablishmentEmployee> updateEstablishmentEmployee(
      EstablishmentEmployee request, bool isEdited) async {
    return _putRequest('', request, isEdited);
  }

  Future<EstablishmentEmployee?> _getRequest(String path, int id) async {
    var token = await storage.read(key: 'token');
    var url = Uri.parse('$_baseUrl$path/$id');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return EstablishmentEmployee?.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<List<EstablishmentEmployee>> _getListRequest(String path) async {
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
          .map((categoryJson) => EstablishmentEmployee.fromJson(categoryJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<EstablishmentEmployee> _postRequest(
      String path, EstablishmentEmployee request) async {
    var token = await storage.read(key: 'token');
    var url = Uri.parse(_baseUrl);
    var multipartRequest = http.MultipartRequest('POST', url);

    multipartRequest.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    multipartRequest.fields['EstablishmentEmployeeId'] =
        request.establishmentEmployeeId.toString();
    multipartRequest.fields['EstablishmentUserProfileId'] =
        request.establishmentUserProfileId.toString();
    multipartRequest.fields['Name'] = request.name;
    multipartRequest.fields['Document'] = request.document;
    multipartRequest.fields['DateOfBirth'] = request.dateOfBirth.toString();
    multipartRequest.fields['Active'] = request.active.toString();
    multipartRequest.fields['Deleted'] = request.deleted.toString();
    /*multipartRequest.fields['CreationDate'] = request.creationDate.toString();
    multipartRequest.fields['LastUpdateDate'] =
        request.lastUpdateDate.toString();*/

    if (request.employeeImage != null) {
      multipartRequest.files.add(
          await http.MultipartFile.fromPath('File', request.employeeImage!));
    }

    http.StreamedResponse streamedResponse = await multipartRequest.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return EstablishmentEmployee.fromJson(jsonResponse);
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<EstablishmentEmployee> _putRequest(
      String path, EstablishmentEmployee request, bool isEdited) async {
    var url = Uri.parse(_baseUrl);
    var multipartRequest = http.MultipartRequest('PUT', url);

    multipartRequest.fields['EstablishmentEmployeeId'] =
        request.establishmentEmployeeId.toString();
    multipartRequest.fields['EstablishmentUserProfileId'] =
        request.establishmentUserProfileId.toString();
    multipartRequest.fields['Name'] = request.name;
    multipartRequest.fields['Document'] = request.document;
    multipartRequest.fields['DateOfBirth'] = request.dateOfBirth.toString();
    multipartRequest.fields['Active'] = request.active.toString();
    multipartRequest.fields['Deleted'] = request.deleted.toString();
    /*multipartRequest.fields['CreationDate'] = request.creationDate.toString();
    multipartRequest.fields['LastUpdateDate'] =
        request.lastUpdateDate.toString();*/

    if (request.employeeImage != null) {
      multipartRequest.files.add(
          await http.MultipartFile.fromPath('File', request.employeeImage!));
    }

    http.StreamedResponse streamedResponse = await multipartRequest.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return EstablishmentEmployee.fromJson(jsonResponse);
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