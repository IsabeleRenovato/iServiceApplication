import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:service_app/utils/token_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_app/models/auth/pre_register.dart';
import 'package:service_app/models/auth/login.dart';
import 'package:service_app/models/user_info.dart';
import '../views/auth_pages/login_page.dart';

class AuthServices {
  final String _baseUrl = 'http://10.0.2.2:5120/Auth/';
  final storage = FlutterSecureStorage();
  late BuildContext _context;

  void init(BuildContext context) {
    _context = context;
  }

  Future<UserInfo> preRegister(PreRegister request) async {
    return _postRequest('preregister', request);
  }

  Future<UserInfo> registerUserProfile(UserInfo request) async {
    return _postRequest('RegisterUserProfile', request);
  }

  Future<UserInfo> registerAddress(UserInfo request) async {
    return _postRequest('RegisterAddress', request);
  }

  Future<UserInfo> login(BuildContext context, Login request) async {
    UserInfo userInfo = await _postRequest('login', request);
    if (userInfo.token != null) {
      await storage.delete(key: 'token');

      // Salve o novo token

      await storage.write(key: 'token', value: userInfo.token);

      // Atualize o TokenProvider

      Provider.of<TokenProvider>(context, listen: false)
          .saveToken(userInfo.token!);

      // Leia o token do armazenamento seguro para verificação
    } else {
      print('Token do usuário é nulo.');
    }

    print('Login response: ${userInfo.toJson()}');
    return userInfo;
  }

  Future<UserInfo> _postRequest(String path, dynamic request) async {
    var url = Uri.parse('$_baseUrl$path');
    var token = await storage.read(key: 'token');
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
      return UserInfo.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Tratar erro de autenticação
      await storage.delete(key: 'token'); // Limpar o token inválido ou expirado
      Navigator.push(
        _context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      throw Exception('Token inválido ou expirado. Faça login novamente.');
    } else {
      _handleError(response.body); // Outros erros
    }

    throw Exception('Não foi possível completar a requisição para $path.');
  }

  Exception _handleError(String responseBody) {
    var jsonResponse = jsonDecode(responseBody);
    var errorMessage = jsonResponse['message'] ?? 'Erro desconhecido';
    throw Exception(errorMessage);
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Remova o token do armazenamento seguro
      await storage.delete(key: 'token');

      Provider.of<TokenProvider>(context, listen: false).deleteToken();

      // Remova outros dados de sessão do shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Redefina o estado da aplicação, se necessário
      // Navegue para a tela de login
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (e) {
      print('Erro ao fazer logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout. Tente novamente.')),
      );
    }
  }
}
