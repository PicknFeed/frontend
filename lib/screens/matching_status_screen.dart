import 'package:flutter/material.dart';
import 'package:minix_flutter/models/request_item.dart';
import 'package:minix_flutter/services/api_service.dart';

class MatchingStatusScreen extends StatefulWidget {
  const MatchingStatusScreen({super.key});

  @override
  State<MatchingStatusScreen> createState() =>
      _MatchingStatusScreenState();
}

class _MatchingStatusScreenState extends State<MatchingStatusScreen> {
  late Future<List<RequestItem>> _future;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    _future = ApiService.fetchMyRequests();
  }

  String _statusText(String status) {
    switch (status) {
      case 'APPROVED':
        return '수락됨';
      case 'REJECTED':
        return '거절됨';
      default:
        return '대기중';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('매칭 상태'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(_loadRequests);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RequestItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('매칭 요청이 없습니다.'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final r = requests[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(r.companyName),
                  trailing: Text(
                    _statusText(r.status),
                    style: TextStyle(
                      color: _statusColor(r.status),
                      fontWeight: FontWeight.bold,
                    ),
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