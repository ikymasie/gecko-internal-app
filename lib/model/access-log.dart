class AccessLog {
  final String id;
  final String attendeeId;
  final String eventId;
  final String accessLevelId;
  final String locationId;
  final DateTime timestamp;
  final String checkpointId;
  final bool accessGranted;

  AccessLog({
    required this.id,
    required this.attendeeId,
    required this.eventId,
    required this.accessLevelId,
    required this.locationId,
    required this.timestamp,
    required this.checkpointId,
    required this.accessGranted,
  });

  factory AccessLog.fromJson(Map<String, dynamic> json) {
    return AccessLog(
      id: json['id'],
      attendeeId: json['attendeeId'],
      eventId: json['eventId'],
      accessLevelId: json['accessLevelId'],
      locationId: json['locationId'],
      timestamp: DateTime.parse(json['timestamp']),
      checkpointId: json['checkpointId'],
      accessGranted: json['accessGranted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendeeId': attendeeId,
      'eventId': eventId,
      'accessLevelId': accessLevelId,
      'locationId': locationId,
      'timestamp': timestamp.toIso8601String(),
      'checkpointId': checkpointId,
      'accessGranted': accessGranted,
    };
  }
}
