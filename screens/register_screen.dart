import 'package:flutter/material.dart';

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

  final Color mainRed = const Color(0xFFE53935);
  final Color borderGray = const Color(0xFFDDDDDD);

  @override
  void initState() {
    super.initState();
    // 🔥 LoginScreen에서 넘어온 role 반영
    userType = widget.role == 'PERSONAL' ? 'personal' : 'company';
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
              onPressed: () {
                // TODO: 실제 회원가입 API 연동 예정
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      userType == 'personal'
                          ? '개인 회원가입 완료'
                          : '기업 회원가입 완료',
                    ),
                  ),
                );

                Navigator.pop(context); // 로그인 화면으로 복귀
              },
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
