import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/service.dart';

class ServiceServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Service';

  Future<Service?> getById(int serviceId) async {
    return _getRequest('', serviceId);
  }

  Future<List<Service>> getServiceByUserProfileId(int userProfileId) async {
    return _getListRequest('/GetServiceByUserProfileId', userProfileId);
  }

  Future<List<String>> getAvailableTimes(
      int userProfileId, DateTime date) async {
    return _getAvailableTimesRequest('/GetAvailableTimes', userProfileId, date);
  }

  Future<Service> addService(Service request) async {
    return _postRequest('', request);
  }

  Future<Service?> _getRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Service?.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<List<Service>> _getListRequest(String path, int id) async {
    var url = Uri.parse('$_baseUrl$path/$id');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((categoryJson) => Service.fromJson(categoryJson))
          .toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<List<String>> _getAvailableTimesRequest(
      String path, int id, DateTime date) async {
    var formattedDate = date.toIso8601String();
    var url = Uri.parse('$_baseUrl$path/$id/$formattedDate');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((time) => time.toString()).toList();
    } else {
      _handleError(response.body);
    }
    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Future<bool> delete(int serviceId) async {
    return _deleteRequest('/SetDeleted', serviceId);
  }

  Future<Service> _postRequest(String path, Service request) async {
    var url = Uri.parse(_baseUrl);
    var multipartRequest = http.MultipartRequest('POST', url);

    multipartRequest.fields['ServiceId'] = request.serviceId.toString();
    multipartRequest.fields['EstablishmentUserProfileId'] =
        request.establishmentUserProfileId.toString();
    multipartRequest.fields['ServiceCategoryId'] =
        request.serviceCategoryId.toString();
    multipartRequest.fields['Name'] = request.name;
    multipartRequest.fields['Description'] = request.description;
    multipartRequest.fields['Price'] = request.price.toString();
    multipartRequest.fields['EstimatedDuration'] =
        request.estimatedDuration.toString();
    multipartRequest.fields['Active'] = request.active.toString();
    multipartRequest.fields['Deleted'] = request.deleted.toString();
    multipartRequest.fields['CreationDate'] = request.creationDate.toString();
    multipartRequest.fields['LastUpdateDate'] =
        request.lastUpdateDate.toString();

    if (request.serviceImage != null) {
      multipartRequest.files.add(
          await http.MultipartFile.fromPath('File', request.serviceImage!));
    }

    http.StreamedResponse streamedResponse = await multipartRequest.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return Service.fromJson(jsonResponse);
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