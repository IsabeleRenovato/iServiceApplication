import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TokenProvider with ChangeNotifier {
  static final _storage = FlutterSecureStorage();
  String? _token;
  Map<String, dynamic>? _decodedToken;

  TokenProvider() {
    _initToken();
  }

  // Método para inicializar o token a partir do armazenamento seguro
  Future<void> _initToken() async {
    final _storage = FlutterSecureStorage();
    _token = await _storage.read(key: 'token');
    if (_token != null) {
      _decodedToken = Jwt.parseJwt(_token!);
    }
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    final _storage = FlutterSecureStorage();

    _decodedToken = Jwt.parseJwt(token);
    await _storage.write(key: 'token', value: token);
    _token = token;
    print('Token salvo: $token');
    notifyListeners();
  }

  // Método para obter o token atual
  String? get token => _token;

  // Método para obter o token decodificado
  Map<String, dynamic>? getDecodedToken() {
    return _decodedToken;
  }

  // Método para remover o token
  Future<void> deleteToken() async {
    _token = null;
    _decodedToken = null;
    await _storage.delete(key: 'token');

    String? deletedToken = await _storage.read(key: 'token');
    if (deletedToken == null) {
      print('Token deletado com sucesso');
    } else {
      print('Falha ao deletar o token. Token atual: $deletedToken');
    }
    notifyListeners();
  }

  // Método para verificar se há um token válido
  bool hasValidToken() {
    return _token != null && _token!.isNotEmpty;
  }
}
