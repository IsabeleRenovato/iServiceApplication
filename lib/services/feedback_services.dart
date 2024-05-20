import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/feedback.dart';

class FeedbackServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Feedback';

  Future<FeedbackModel> addFeeback(FeedbackModel request) async {
    return _postRequest('', request);
  }

  Future<FeedbackModel> _postRequest(String path, FeedbackModel request) async {
    var url = Uri.parse('$_baseUrl$path');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return FeedbackModel.fromJson(jsonDecode(response.body));
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
