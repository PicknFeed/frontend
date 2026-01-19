class MeUser {
  final int id;
  final String email;
  final String name;
  final String role;

  MeUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory MeUser.fromJson(Map<String, dynamic> json) {
    return MeUser(
      id: (json['id'] ?? 0) as int,
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      role: (json['role'] ?? 'PERSONAL').toString(),
    );
  }
}

class MeProfile {
  final int userId;
  final String resumeText;
  final String position;
  final List<String> skills;

  MeProfile({
    required this.userId,
    required this.resumeText,
    required this.position,
    required this.skills,
  });

  factory MeProfile.fromJson(Map<String, dynamic> json) {
    final rawSkills = (json['skills'] ?? '').toString();
    final skills = rawSkills
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return MeProfile(
      userId: (json['user_id'] ?? json['userId'] ?? 0) as int,
      resumeText: (json['resume_text'] ?? '').toString(),
      position: (json['position'] ?? '').toString(),
      skills: skills,
    );
  }
}

class MeResponse {
  final MeUser user;
  final MeProfile profile;

  MeResponse({required this.user, required this.profile});

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    final userJson = (json['user'] ?? {}) as Map<String, dynamic>;
    final profileJson = (json['profile'] ?? {}) as Map<String, dynamic>;

    return MeResponse(
      user: MeUser.fromJson(userJson),
      profile: MeProfile.fromJson(profileJson),
    );
  }
}