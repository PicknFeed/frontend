import 'package:flutter/material.dart';
import 'package:minix_flutter/models/company.dart';
import 'package:minix_flutter/services/api_service.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Company company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(company.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.position,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              '기술 스택',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: company.skills
                  .map((s) => Chip(label: Text(s)))
                  .toList(),
            ),

            const Spacer(),

            /// 매칭 요청 버튼 (⭐ 수정 포인트)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final success =
                      await ApiService.requestMatching(company.id);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('매칭 요청이 전송되었습니다'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('요청에 실패했습니다'),
                      ),
                    );
                  }
                },
                child: const Text('매칭 요청'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
