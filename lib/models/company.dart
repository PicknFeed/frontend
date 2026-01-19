class Company {
  final int id;
  final String name;
  final String position;
  final List<String> skills;
  final String description;

  Company({
    required this.id,
    required this.name,
    required this.position,
    required this.skills,
    required this.description,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      position: json['position'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      description: (json['description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'skills': skills,
      'description': description,
    };
  }
}
