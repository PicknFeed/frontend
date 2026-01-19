import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EvaluationWriteScreen extends StatefulWidget {
  final int requestId;
  final String personName;

  const EvaluationWriteScreen({
    super.key,
    required this.requestId,
    required this.personName,
  });

  @override
  State<EvaluationWriteScreen> createState() =>
      _EvaluationWriteScreenState();
}

class _EvaluationWriteScreenState extends State<EvaluationWriteScreen> {
  int score = 3;
  final TextEditingController commentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('평가 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 개인 이름 (표시용)
            Text(
              widget.personName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 점수
            const Text('평가 점수'),
            Slider(
              value: score.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: score.toString(),
              onChanged: (v) {
                setState(() => score = v.toInt());
              },
            ),

            /// 코멘트
            TextField(
              controller: commentCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: '평가 내용을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ApiService.submitEvaluation(
                    requestId: widget.requestId,
                    score: score,
                    comment: commentCtrl.text,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('평가가 등록되었습니다'),
                      ),
                    );
                  }
                },
                child: const Text('평가 등록'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}