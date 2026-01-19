import 'package:flutter/material.dart';
import 'package:minix_flutter/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final String role; // PERSONAL | COMPANY

  const RegisterScreen({
    super.key,
    required this.role,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String userType; // personal | company

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final Color mainRed = const Color(0xFFE53935);
  final Color borderGray = const Color(0xFFDDDDDD);

  @override
  void initState() {
    super.initState();
    // 🔥 LoginScreen에서 넘어온 role 반영
    userType = widget.role == 'PERSONAL' ? 'personal' : 'company';
  }

  Future<void> _handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 정보를 입력해주세요')),
      );
      return;
    }

    final success = await AuthService().register(
      email: email,
      password: password,
      name: name,
      role: userType.toUpperCase(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공! 로그인 해주세요.')),
      );
      Navigator.pop(context); // 로그인 화면으로 복귀
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 실패. 이메일을 확인해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            /// 사용자 유형 선택
            const Text(
              '사용자 유형',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: borderGray),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: userType,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'personal',
                      child: Text('개인 사용자'),
                    ),
                    DropdownMenuItem(
                      value: 'company',
                      child: Text('기업 사용자'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 이름
             TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: '이름',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 이메일
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: '이메일',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 비밀번호
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// 회원가입 완료 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _handleRegister,
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
