class UserProfile {
  Map<String, String> platforms;

  UserProfile({required this.platforms});

  factory UserProfile.empty() => UserProfile(platforms: {});

  Map<String, dynamic> toJson() => {'platforms': platforms};

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      platforms: Map<String, String>.from(json['platforms'] ?? {}),
    );
  }
}

