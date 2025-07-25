import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.role == 'ROLE_ADMIN';
  bool get isLoading => _isLoading;

  String? get username => _user?.name ?? _user?.username;
  String? get email => _user?.username; // If backend supports separate email, adjust this

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultToken = await AuthService.signIn(username, password);
      if (resultToken != null) {
        _token = resultToken;

        final fetchedUser = await AuthService.getMe();
        if (fetchedUser != null) {
          _user = User(
            id: fetchedUser.id,
            username: fetchedUser.username,
            role: fetchedUser.role,
            createdAt: fetchedUser.createdAt,
            name: fetchedUser.name,
            avatarUrl: fetchedUser.avatarUrl,
            token: resultToken,
          );
        }
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final valid = await AuthService.validateToken();
    if (!valid) return;

    final storedToken = await AuthService.getToken();
    if (storedToken == null) return;

    final fetchedUser = await AuthService.getMe();
    if (fetchedUser != null) {
      _token = storedToken;
      _user = User(
        id: fetchedUser.id,
        username: fetchedUser.username,
        role: fetchedUser.role,
        createdAt: fetchedUser.createdAt,
        name: fetchedUser.name,
        avatarUrl: fetchedUser.avatarUrl,
        token: storedToken,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await AuthService.deleteToken();
    notifyListeners();
  }
}



// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import '../models/user.dart';

// enum AuthStatus { initial, authenticated, unauthenticated, loading }

// class AuthProvider extends ChangeNotifier {
//   AuthStatus _status = AuthStatus.initial;
//   User? _user;
//   String? _errorMessage;
//   String? _token;

//   AuthStatus get status => _status;
//   User? get user => _user;
//   String? get errorMessage => _errorMessage;
//   bool get isAuthenticated => _status == AuthStatus.authenticated;
//   bool get isLoading => _status == AuthStatus.loading;
//   String? get token => _token;

//   /// Use localhost for Flutter Web in Chrome
//   final String baseUrl = 'http://localhost:8080';

//   /// Log in method
//   Future<void> login(String email, String password) async {
//     _status = AuthStatus.loading;
//     notifyListeners();

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/auth/sign-in'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': email,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         _token = data['token'];

//         _user = User(
//           id: data['user']?['id'] ?? 'temp-id',
//           email: data['user']?['email'] ?? email,
//           name: data['user']?['name'] ?? 'User',
//           avatarUrl: data['user']?['avatarUrl'],
//           role: data['user']?['role'] ?? 'user',
//           createdAt: DateTime.tryParse(data['user']?['createdAt'] ?? '') ?? DateTime.now(),
//         );

//         _status = AuthStatus.authenticated;
//       } else {
//         _status = AuthStatus.unauthenticated;
//         _errorMessage = 'Неверный логин или пароль';
//       }
//     } catch (e) {
//       _status = AuthStatus.unauthenticated;
//       _errorMessage = 'Ошибка входа: $e';
//     }

//     notifyListeners();
//   }

//   /// Used inside AuthScreen for login button
//   Future<bool> signIn(String email, String password) async {
//     await login(email, password);
//     return isAuthenticated;
//   }

//   /// Used for signup in AuthScreen
//   Future<bool> signUp(String name, String email, String password) async {
//     _status = AuthStatus.loading;
//     notifyListeners();

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/auth/sign-up'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'name': email,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return await signIn(email, password);
//       } else {
//         _status = AuthStatus.unauthenticated;
//         _errorMessage = 'Ошибка регистрации';
//       }
//     } catch (e) {
//       _status = AuthStatus.unauthenticated;
//       _errorMessage = 'Ошибка регистрации: $e';
//     }

//     notifyListeners();
//     return false;
//   }

//   /// Logout method
//   Future<void> logout() async {
//     _token = null;
//     _user = null;
//     _status = AuthStatus.unauthenticated;
//     notifyListeners();
//   }

//   /// Clear error message
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   /// Demo credentials for testing
//   List<Map<String, String>> get demoCredentials => [
//         {
//           'name': 'Админ',
//           'role': 'admin',
//           'email': 'admin@trubo.kz',
//           'password': 'admin123',
//         },
//         {
//           'name': 'Пользователь',
//           'role': 'user',
//           'email': 'user@trubo.kz',
//           'password': 'user123',
//         },
//       ];
// }
