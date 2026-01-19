import 'package:flutter/material.dart';

class PersonalProfileForm extends StatelessWidget {
  PersonalProfileForm({super.key});

  final TextEditingController jobController = TextEditingController();
  final TextEditingController introController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인 프로필 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              '희망 직무',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(
                hintText: '예) Backend Developer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '자기소개',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: introController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: '자신을 간단히 소개해주세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '기술 스택',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Flutter')),
                Chip(label: Text('Node.js')),
                Chip(label: Text('MySQL')),
              ],
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('개인 프로필이 등록되었습니다'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}