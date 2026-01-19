class ResumeFile {
  final int id;
  final String originalName;
  final String url;
  final String createdAt;

  ResumeFile({
    required this.id,
    required this.originalName,
    required this.url,
    required this.createdAt,
  });

  factory ResumeFile.fromJson(Map<String, dynamic> json) {
    return ResumeFile(
      id: json['id'],
      originalName: (json['originalName'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? json['created_at'] ?? '').toString(),
    );
  }
}