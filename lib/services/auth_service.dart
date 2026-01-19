import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class LoginResult {
  final String token;
  final String role;

  LoginResult({required this.token, required this.role});
}

class AuthService {
  Future<LoginResult?> login(String email, String password) async {
    final response = await http
        .post(
          Uri.parse('${ApiService.baseUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      final token = (data['token'] ?? data['accessToken'])?.toString();
      final role = (data['user']?['role'] ?? data['role'])?.toString(); // user.role 체크

      if (token == null || token.isEmpty) return null;

      return LoginResult(
        token: token,
        role: (role == null || role.isEmpty) ? 'PERSONAL' : role,
      );
    }

    return null;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final response = await http
        .post(
          Uri.parse('${ApiService.baseUrl}/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
            'name': name.trim(),
            'role': role,
          }),
        )
        .timeout(const Duration(seconds: 8));

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}