class Session {
  final String id;
  final String eventId;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String locationId;
  final String accessLevelId;

  Session({
    required this.id,
    required this.eventId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.locationId,
    required this.accessLevelId,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      locationId: json['locationId'],
      accessLevelId: json['accessLevelId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'locationId': locationId,
      'accessLevelId': accessLevelId,
    };
  }
}
