import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResult {
  final String token;
  final String role;

  LoginResult({required this.token, required this.role});
}

class AuthService {
  static const String baseUrl = 'http://localhost:3000';

  Future<LoginResult?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResult(
        token: data['token'],
        role: data['role'], // PERSONAL / COMPANY
      );
    }

    return null;
  }
}
