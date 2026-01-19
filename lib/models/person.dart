class Person {
  final String name;
  final String position;
  final List<String> skills;

  Person(this.name, this.position, this.skills);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['name'],
      json['position'],
      List<String>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'skills': skills,
    };
  }
}
