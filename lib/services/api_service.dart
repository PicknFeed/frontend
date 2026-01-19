import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minix_flutter/models/company.dart';
import 'package:minix_flutter/models/person.dart';
import 'package:minix_flutter/models/matching.dart';
import 'package:minix_flutter/models/evaluation.dart';
import 'package:minix_flutter/models/request_item.dart';
import 'package:minix_flutter/utils/token_storage.dart';
import 'package:minix_flutter/models/me_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:minix_flutter/models/resume_file.dart';

class ApiService {
  // Windows 노트북 IPv4
  static const String pcIp = '192.168.0.32';

  // iPhone에서 접근할 백엔드 주소
  static const String host = 'http://$pcIp:3000';

  // 백엔드는 /api prefix 사용
  static const String baseUrl = '$host/api';


  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // 마이페이지용: 내 정보 + 프로필 조회
  static Future<MeResponse?> fetchMe() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return MeResponse.fromJson(data);
  }

  // ✅ 내 이력서 목록 조회
  static Future<List<ResumeFile>> fetchMyResumes() async {
    final res = await http.get(
      Uri.parse('$baseUrl/resumes/me'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];
    final List data = jsonDecode(res.body);
    return data.map((e) => ResumeFile.fromJson(e)).toList();
  }

  // ✅ 이력서 업로드 (PDF)
  static Future<bool> uploadResume(PlatformFile file) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$baseUrl/resumes');

    final req = http.MultipartRequest('POST', uri);
    if (token != null) req.headers['Authorization'] = 'Bearer $token';

    // 웹은 bytes로 오는 경우가 많음
    if (file.bytes != null) {
      req.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ),
      );
    } else if (file.path != null) {
      req.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: file.name,
        ),
      );
    } else {
      return false;
    }

    final streamed = await req.send();
    return streamed.statusCode == 200 || streamed.statusCode == 201;
  }

  // 연결 확인용: iPhone Safari로도 접속 테스트 가능
  // http://192.168.0.31:3000/api/ping
  static Future<bool> ping() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/ping'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ------------------ 아래는 기존 API들 (/api 반영) ------------------

  static Future<List<Company>> fetchCompanies() async {
    final res = await http.get(
      Uri.parse('$baseUrl/companies'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Company.fromJson(e)).toList();
  }


  static Future<List<Person>> fetchPeople() async {
    final res = await http.get(
      Uri.parse('$baseUrl/people'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Person.fromJson(e)).toList();
  }


  static Future<bool> saveProfile(Map<String, dynamic> profileData) async {
    final res = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: await _headers(),
      body: jsonEncode(profileData),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }


  static Future<bool> requestMatching(int companyId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/personal/requests'),
      headers: await _headers(),
      body: jsonEncode({'companyId': companyId}),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }


  static Future<List<RequestItem>> fetchMyRequests() async {
    final res = await http.get(
      Uri.parse('$baseUrl/personal/requests'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => RequestItem.fromJson(e)).toList();
  }


  static Future<List<Matching>> fetchCompanyMatchings() async {
    final res = await http.get(
      Uri.parse('$baseUrl/company/requests'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Matching.fromJson(e)).toList();
  }


  static Future<bool> respondMatching({
    required int requestId,
    required bool accept,
  }) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/company/requests/$requestId'),
      headers: await _headers(),
      body: jsonEncode({
        'status': accept ? 'APPROVED' : 'REJECTED',
      }),
    );

    return res.statusCode == 200;
  }


  static Future<bool> submitEvaluation({
    required int requestId,
    required int score,
    required String comment,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/evaluation'),
      headers: await _headers(),
      body: jsonEncode({
        'requestId': requestId,
        'score': score,
        'comment': comment,
      }),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }


  static Future<List<Evaluation>> fetchMyEvaluations() async {
    final res = await http.get(
      Uri.parse('$baseUrl/evaluation/me'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Evaluation.fromJson(e)).toList();
  }
  
}
