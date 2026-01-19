class Company {
  final int id;
  final String name;
  final String position;
  final List<String> skills;

  Company({
    required this.id,
    required this.name,
    required this.position,
    required this.skills,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      skills: List<String>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'skills': skills,
    };
  }
}
