class Profile {
  final String id;
  final String userId;
  final String username;
  final String? fullName;
  final String? bio;
  final String? jobTitle;
  final String? company;
  final String? email;
  final String? phone;
  final String? location;
  final String? photoUrl;
  final String? bannerColor;
  final String? bannerImageUrl;
  final String? theme;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.username,
    this.fullName,
    this.bio,
    this.jobTitle,
    this.company,
    this.email,
    this.phone,
    this.location,
    this.photoUrl,
    this.bannerColor,
    this.bannerImageUrl,
    this.theme,
    this.isPublic = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      fullName: json['full_name'],
      bio: json['bio'],
      jobTitle: json['job_title'],
      company: json['company'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      photoUrl: json['photo_url'],
      bannerColor: json['banner_color'],
      bannerImageUrl: json['banner_image_url'],
      theme: json['theme'],
      isPublic: json['is_public'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'bio': bio,
      'job_title': jobTitle,
      'company': company,
      'email': email,
      'phone': phone,
      'location': location,
      'photo_url': photoUrl,
      'banner_color': bannerColor,
      'banner_image_url': bannerImageUrl,
      'theme': theme,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
