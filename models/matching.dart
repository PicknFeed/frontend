class Matching {
  final int requestId;
  final String personName;
  final String companyName;
  final String position;
  final List<String> skills;
  final String status; // PENDING / APPROVED / REJECTED

  Matching({
    required this.requestId,
    required this.personName,
    required this.companyName,
    required this.position,
    required this.skills,
    required this.status,
  });

  factory Matching.fromJson(Map<String, dynamic> json) {
    return Matching(
      requestId: json['requestId'],
      personName: json['personName'] ?? '',
      companyName: json['companyName'] ?? '',
      position: json['position'] ?? '',
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : [],
      status: json['status'] ?? 'PENDING',
    );
  }
}
