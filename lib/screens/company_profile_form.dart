import 'package:flutter/material.dart';

class CompanyProfileForm extends StatelessWidget {
  CompanyProfileForm({super.key});

  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기업 프로필 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              '기업명',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(
                hintText: '기업명을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '채용 포지션',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(
                hintText: '예) Flutter Developer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '채용 설명',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: '업무 내용 및 요구 사항',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '필요 기술',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Flutter')),
                Chip(label: Text('REST')),
                Chip(label: Text('DB')),
              ],
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('기업 프로필이 등록되었습니다'),
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