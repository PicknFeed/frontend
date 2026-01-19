// lib/screens/my_page_screen.dart
import 'package:flutter/material.dart';
import '../models/me_response.dart';
import '../services/api_service.dart';

import 'my_request_screen.dart';
import 'evaluation_result_screen.dart';

class MyPageScreen extends StatefulWidget {
  final String role; // 'PERSONAL' / 'COMPANY'
  const MyPageScreen({super.key, required this.role});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late Future<MeResponse?> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchMe();
  }

  void _reload() {
    setState(() {
      _future = ApiService.fetchMe();
    });
  }

  Future<void> _openEdit(MeResponse me) async {
    final positionCtrl = TextEditingController(text: me.profile.position);
    final resumeCtrl = TextEditingController(text: me.profile.resumeText);
    final skillsCtrl = TextEditingController(text: me.profile.skills.join(', '));

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('내 프로필 수정'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: positionCtrl,
                  decoration: const InputDecoration(
                    labelText: '희망 직무',
                    hintText: '예) Backend Developer',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: resumeCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: '자기소개',
                    hintText: '간단히 소개해주세요',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: skillsCtrl,
                  decoration: const InputDecoration(
                    labelText: '기술 스택',
                    hintText: '예) Flutter, Node.js, MySQL',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('저장'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    final skills = skillsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final success = await ApiService.saveProfile({
      // 백엔드가 resume_text/position/skills 지원하도록 이미 맞춰둔 상태
      'resume_text': resumeCtrl.text,
      'position': positionCtrl.text,
      'skills': skills,
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 저장되었습니다')),
      );
      _reload();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPersonal = widget.role == 'PERSONAL';

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<MeResponse?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final me = snapshot.data;
          if (me == null) {
            return const Center(child: Text('내 정보를 불러올 수 없습니다.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ✅ 내 계정 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        me.user.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(me.user.email),
                      const SizedBox(height: 6),
                      Text('ROLE: ${me.user.role}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ✅ 내 프로필/이력서 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('희망 직무', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(me.profile.position.isEmpty ? '-' : me.profile.position),
                      const SizedBox(height: 14),

                      const Text('자기소개', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(me.profile.resumeText.isEmpty ? '-' : me.profile.resumeText),
                      const SizedBox(height: 14),

                      const Text('기술 스택', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (me.profile.skills.isEmpty)
                        const Text('-')
                      else
                        Wrap(
                          spacing: 8,
                          children: me.profile.skills.map((s) => Chip(label: Text(s))).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ 액션 버튼들
              if (isPersonal) ...[
                // 1) 프로필 수정
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: () => _openEdit(me),
                    icon: const Icon(Icons.edit),
                    label: const Text('내 프로필 수정'),
                  ),
                ),
                const SizedBox(height: 10),

                // 2) 내 요청 목록
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyRequestScreen()),
                      );
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text('내 요청 목록'),
                  ),
                ),
                const SizedBox(height: 10),

                // 3) 내 평가 피드백
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EvaluationResultScreen()),
                      );
                    },
                    icon: const Icon(Icons.rate_review),
                    label: const Text('내 평가 피드백'),
                  ),
                ),
              ] else ...[
                // 기업/관리자: 우선 프로필 수정만 제공 (원하면 기업용 마이페이지 확장 가능)
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: () => _openEdit(me),
                    icon: const Icon(Icons.edit),
                    label: const Text('프로필 수정'),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}