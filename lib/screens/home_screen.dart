import 'package:flutter/material.dart';
// import 'package:minix_flutter/models/company.dart';
// import 'package:minix_flutter/models/person.dart';
import 'package:minix_flutter/screens/company_detail_screen.dart';
import 'package:minix_flutter/screens/personal_profile_form.dart';
import 'package:minix_flutter/screens/company_profile_form.dart';
import 'package:minix_flutter/services/api_service.dart';
import 'package:minix_flutter/screens/company_matching_screen.dart';
import 'package:minix_flutter/screens/my_request_screen.dart';
import 'package:minix_flutter/screens/login_screen.dart';
// import 'package:minix_flutter/utils/token_storage.dart';

class HomeScreen extends StatelessWidget {
  /// PERSONAL / COMPANY
  final String role;

  const HomeScreen({super.key, required this.role});

  bool get isPersonal => role == 'PERSONAL';
  bool get isCompany => role == 'COMPANY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPersonal ? '기업 / 채용 탐색' : '개인 사용자 탐색'),
        actions: [
          /// 기업 사용자: 매칭 관리
          if (isCompany)
            IconButton(
              icon: const Icon(Icons.assignment),
              tooltip: '매칭 관리',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CompanyMatchingScreen(),
                  ),
                );
              },
            ),

          /// 개인 사용자: 요청 상태 확인
          if (isPersonal)
            IconButton(
              icon: const Icon(Icons.list_alt),
              tooltip: '내 요청 상태',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyRequestScreen(),
                  ),
                );
              },
            ),

          /// 프로필 등록
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      isPersonal ? PersonalProfileForm() : CompanyProfileForm(),
                ),
              );
            },
            child: const Text(
              '프로필',
              style: TextStyle(color: Colors.white),
            ),
          ),

          /// 로그아웃
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: () async {
              await TokenStorage.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),

      body: isPersonal
          ? const CompanySearchView()
          : const PersonSearchView(),
    );
  }
}

/* ===========================================================
   개인 로그인 → 기업 목록
=========================================================== */

class CompanySearchView extends StatefulWidget {
  const CompanySearchView({super.key});

  @override
  State<CompanySearchView> createState() => _CompanySearchViewState();
}

class _CompanySearchViewState extends State<CompanySearchView> {
  String keyword = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 검색창
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '기업 검색',
            ),
            onChanged: (value) {
              setState(() {
                keyword = value;
              });
            },
          ),
        ),

        /// 기업 리스트
        Expanded(
          child: FutureBuilder<List<Company>>(
            future: ApiService.fetchCompanies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('등록된 기업이 없습니다.'));
              }

              final companies = snapshot.data!
                  .where(
                    (c) => c.name
                        .toLowerCase()
                        .contains(keyword.toLowerCase()),
                  )
                  .toList();

              return ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(company.name),
                      subtitle: Text(company.position),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CompanyDetailScreen(company: company),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/* ===========================================================
   기업 로그인 → 개인 목록
=========================================================== */

class PersonSearchView extends StatelessWidget {
  const PersonSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Person>>(
      future: ApiService.fetchPeople(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('등록된 개인 사용자가 없습니다.'));
        }

        final people = snapshot.data!;

        return ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final p = people[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(p.name),
                subtitle: Text('${p.position} - ${p.skills.join(', ')}'),
              ),
            );
          },
        );
      },
    );
  }
}