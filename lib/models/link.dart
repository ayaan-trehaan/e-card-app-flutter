class LinkModel {
  final String id;
  final String profileId;
  final String url;
  final String title;
  final String iconName;
  final int sortOrder;
  final DateTime createdAt;

  LinkModel({
    required this.id,
    required this.profileId,
    required this.url,
    required this.title,
    required this.iconName,
    required this.sortOrder,
    required this.createdAt,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      id: json['id'],
      profileId: json['profile_id'],
      url: json['url'],
      title: json['title'],
      iconName: json['icon_name'] ?? 'Link',
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'url': url,
      'title': title,
      'icon_name': iconName,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
