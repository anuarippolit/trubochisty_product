import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _baseUrl = 'http://localhost:8080'; // заменишь на свой

  static Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
  }

  static Future<bool> validateToken() async {
    final token = await getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/validate?token=$token'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['valid'] == true;
    }
    return false;
  }

  static Future<String?> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      await saveToken(token);
      return token;
    }
    return null;
  }

  static Future<User?> getMe() async {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    }
    return null;
  }
}
