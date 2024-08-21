import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_app/models/via_cep.dart';
import 'package:service_app/utils/baseurlAPI.dart';

class ViaCepServices {
  Future<ViaCep> getAddress(String cep) async {
    var url = Uri.parse('${baseUrlAPI().APIUrl}/Search/$cep');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return ViaCep.fromJson(jsonResponse);
    } else {
      var jsonResponse = jsonDecode(response.body);
      var errorMessage = jsonResponse['message'] ?? 'Erro desconhecido';
      throw Exception(errorMessage);
    }
  }
}
