import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(project.description),
      ),
    );
  }
}