class Vendor {
  final String id;
  final String name;
  final List<String> itemIds;

  Vendor({
    required this.id,
    required this.name,
    required this.itemIds,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: json['name'],
      itemIds: List<String>.from(json['itemIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'itemIds': itemIds,
    };
  }
}
