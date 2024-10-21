class Location {
  final String id;
  final String eventId;
  final String name;
  final int capacity;
  final String? description;
  final List<String> accessLevelIds;

  Location({
    required this.id,
    required this.eventId,
    required this.name,
    required this.capacity,
    this.description,
    required this.accessLevelIds,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      capacity: json['capacity'],
      description: json['description'],
      accessLevelIds: List<String>.from(json['accessLevelIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'capacity': capacity,
      'description': description,
      'accessLevelIds': accessLevelIds,
    };
  }
}
