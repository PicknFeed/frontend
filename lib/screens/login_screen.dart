import 'package:flutter/material.dart';
import 'package:minix_flutter/screens/register_screen.dart';
import 'package:minix_flutter/screens/home_screen.dart';
import 'package:minix_flutter/services/auth_service.dart';
import 'package:minix_flutter/utils/token_storage.dart';
import 'package:minix_flutter/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedUserType = '개인 사용자';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Color mainRed = const Color(0xFFE53935);
  final Color borderGray = const Color(0xFFDDDDDD);
  final Color textGray = const Color(0xFF888888);

  String get selectedRole =>
      selectedUserType == '개인 사용자' ? 'PERSONAL' : 'COMPANY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.work_outline,
                  size: 64,
                  color: mainRed,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Career Matching',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  '개인 → 기업 탐색 · 매칭 · 체크/점수형 평가 피드백',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: textGray,
                  ),
                ),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGray),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedUserType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: '개인 사용자',
                          child: Text('개인 사용자'),
                        ),
                        DropdownMenuItem(
                          value: '기업 사용자',
                          child: Text('기업 사용자'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedUserType = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: '이메일',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderGray),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: '비밀번호',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderGray),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('이메일과 비밀번호를 입력하세요'),
                          ),
                        );
                        return;
                      }

                      // ✅ (선택) baseUrl이 맞는지 1초 컷 체크
                      final pingOk = await ApiService.ping();
                      if (!pingOk) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '서버 연결 실패: ${ApiService.baseUrl}',
                            ),
                          ),
                        );
                        return;
                      }

                      final result = await AuthService().login(
                        emailController.text.trim(),
                        passwordController.text,
                      );

                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인 실패')),
                        );
                        return;
                      }

                      await TokenStorage.saveToken(result.token);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(role: result.role),
                        ),
                      );
                    },
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: mainRed,
                      side: BorderSide(color: mainRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterScreen(role: selectedRole),
                        ),
                      );
                    },
                    child: const Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}