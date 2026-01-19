import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minix_flutter/models/company.dart';
import 'package:minix_flutter/models/person.dart';
import 'package:minix_flutter/models/matching.dart';
import 'package:minix_flutter/models/evaluation.dart';
import 'package:minix_flutter/models/request_item.dart';
import 'package:minix_flutter/utils/token_storage.dart';

class ApiService {
  static const String baseUrl = 'http://서버주소:포트';

  /* ===========================================================
     공통 헤더 (JWT 자동 포함)
  =========================================================== */
  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /* ===========================================================
     개인 → 기업 목록 조회
  =========================================================== */
  static Future<List<Company>> fetchCompanies() async {
    final res = await http.get(
      Uri.parse('$baseUrl/companies'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Company.fromJson(e)).toList();
  }

  /* ===========================================================
     기업 → 개인 목록 조회
  =========================================================== */
  static Future<List<Person>> fetchPeople() async {
    final res = await http.get(
      Uri.parse('$baseUrl/people'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Person.fromJson(e)).toList();
  }

  /* ===========================================================
     프로필 등록 / 수정 (개인 / 기업 공통)
  =========================================================== */
  static Future<bool> saveProfile(Map<String, dynamic> profileData) async {
    final res = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: await _headers(),
      body: jsonEncode(profileData),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  /* ===========================================================
     개인 → 기업 매칭 요청
  =========================================================== */
  static Future<bool> requestMatching(int companyId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/personal/requests'),
      headers: await _headers(),
      body: jsonEncode({'companyId': companyId}),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  /* ===========================================================
     개인 → 내가 요청한 매칭 목록
  =========================================================== */
  static Future<List<RequestItem>> fetchMyRequests() async {
    final res = await http.get(
      Uri.parse('$baseUrl/personal/requests'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => RequestItem.fromJson(e)).toList();
  }

  /* ===========================================================
     기업 → 받은 매칭 요청 목록
  =========================================================== */
  static Future<List<Matching>> fetchCompanyMatchings() async {
    final res = await http.get(
      Uri.parse('$baseUrl/company/requests'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => Matching.fromJson(e)).toList();
  }

  /* ===========================================================
     기업 → 매칭 승인 / 거절
  =========================================================== */
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

  /* ===========================================================
     기업 → 평가 등록
  =========================================================== */
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

  /* ===========================================================
     개인 → 내 평가 조회
  =========================================================== */
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
