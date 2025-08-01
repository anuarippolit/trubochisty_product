import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user.dart';
import 'token_storage.dart';

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
  final url = Uri.parse('$_baseUrl/auth/sign-in');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    print('signIn response code: ${response.statusCode}');
    print('signIn response body: ${response.body}');

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body);
      final tokenString = token['token'];
      await TokenStorage.saveToken(tokenString);
      return tokenString;
    } else {
      // 👇 Print error response to see what's going wrong
      print('Login failed: ${response.statusCode} ${response.body}');
      return null;
    }
  } catch (e) {
    print('Login exception: $e');
    return null;
  }
}


  static Future<User?> getMe() async {
  final token = await TokenStorage.getToken();
  print('getMe(): token = $token');

  final response = await http.get(
    Uri.parse('http://localhost:8080/auth/me'), // убедись, что это правильный URL
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print('getMe(): status = ${response.statusCode}');
  print('getMe(): body = ${response.body}');

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return User.fromJson(json); // ← сюда точно заходит?
  } else {
    print('getMe(): failed');
    return null;
  }
}


}
