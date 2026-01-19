import 'package:flutter/material.dart';
import '../models/matching.dart';
import '../services/api_service.dart';
import 'evaluation_write_screen.dart';

class CompanyMatchingScreen extends StatefulWidget {
  const CompanyMatchingScreen({super.key});

  @override
  State<CompanyMatchingScreen> createState() =>
      _CompanyMatchingScreenState();
}

class _CompanyMatchingScreenState extends State<CompanyMatchingScreen> {
  late Future<List<Matching>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchCompanyMatchings();
  }

  void _reload() {
    setState(() {
      _future = ApiService.fetchCompanyMatchings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('매칭 요청 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<Matching>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('매칭 요청이 없습니다.'));
          }

          final list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final m = list[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.personName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text('지원 포지션: ${m.position}'),
                      const SizedBox(height: 6),

                      Wrap(
                        spacing: 6,
                        children: m.skills
                            .map((s) => Chip(label: Text(s)))
                            .toList(),
                      ),

                      const SizedBox(height: 12),

                      if (m.status == 'PENDING') ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  await ApiService.respondMatching(
                                    requestId: m.requestId,
                                    accept: true,
                                  );
                                  _reload();
                                },
                                child: const Text('수락'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  await ApiService.respondMatching(
                                    requestId: m.requestId,
                                    accept: false,
                                  );
                                  _reload();
                                },
                                child: const Text('거절'),
                              ),
                            ),
                          ],
                        ),
                      ] else if (m.status == 'APPROVED') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EvaluationWriteScreen(
                                    requestId: m.requestId,
                                    personName: m.personName,
                                  ),
                                ),
                              );
                            },
                            child: const Text('평가 작성'),
                          ),
                        ),
                      ] else ...[
                        Text(
                          '상태: ${m.status}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
