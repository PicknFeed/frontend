import 'package:flutter/material.dart';
import '../models/project.dart';
import 'project_detail_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      Project('Flutter 앱', '이력서 앱 제작'),
      Project('콘솔 게임', 'C 기반 TCP 게임'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('프로젝트')),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(projects[index].title),
              subtitle: Text(projects[index].description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectDetailScreen(project: projects[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
