import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';

class ResumeUploadScreen extends StatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  bool uploading = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // 웹에서 bytes 필요
    );

    if (result == null || result.files.isEmpty) return;

    setState(() => uploading = true);
    final ok = await ApiService.uploadResume(result.files.first);
    if (!mounted) return;

    setState(() => uploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '업로드 완료' : '업로드 실패')),
    );

    if (ok) Navigator.pop(context, true); // 업로드 성공 알림
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이력서 업로드')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'PDF 이력서를 업로드하면 마이페이지에서 계속 모아볼 수 있어요.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: uploading ? null : _pickAndUpload,
                icon: uploading
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file),
                label: Text(uploading ? '업로드 중...' : 'PDF 선택 후 업로드'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
