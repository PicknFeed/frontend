import 'package:flutter/material.dart';
import '../models/evaluation.dart';
import '../services/api_service.dart';

class EvaluationResultScreen extends StatelessWidget {
  const EvaluationResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('평가 피드백')),
      body: FutureBuilder<List<Evaluation>>(
        future: ApiService.fetchMyEvaluations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('평가 내역이 없습니다.'));
          }

          final list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final e = list[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(e.evaluator),
                  subtitle: Text(e.comment),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${e.score}점',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        e.createdAt,
                        style: const TextStyle(fontSize: 11),
                      ),
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
