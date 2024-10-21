class TicketType {
  final String id;
  final String eventId;
  final String name;
  final num price;
  final num initialBalance;
  final List<String> accessLevelIds;

  TicketType({
    required this.id,
    required this.eventId,
    required this.name,
    required this.price,
    required this.initialBalance,
    required this.accessLevelIds,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      name: json['name'],
      price: json['price'].toDouble(),
      initialBalance: json['initialBalance'].toDouble(),
      accessLevelIds: List<String>.from(json['accessLevelIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'price': price,
      'initialBalance': initialBalance,
      'accessLevelIds': accessLevelIds,
    };
  }
}
