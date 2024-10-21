class AccessLevel {
  final String id;
  final String name;
  final String? description;

  AccessLevel({
    required this.id,
    required this.name,
    this.description,
  });

  factory AccessLevel.fromJson(Map<String, dynamic> json) {
    return AccessLevel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
