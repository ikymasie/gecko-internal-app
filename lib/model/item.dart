class Item {
  final String id;
  final String vendorId;
  final String name;
  final double price;
  final String? description;

 Item({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.price,
    this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      vendorId: json['vendorId'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}
