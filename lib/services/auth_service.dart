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
      final role = (data['user']?['role'] ?? '').toString(); // ✅ 백엔드 구조

      if (token == null || token.isEmpty) return null;

      return LoginResult(
        token: token,
        role: role.isEmpty ? 'user' : role,
      );
    }

    return null;
  }
}
