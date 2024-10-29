class TopUp {
  final String id;
  final num balanceBefore;
  final num balanceAfter;
  final String stationId;
  final String stationName;
  final String locationId;
  final String locationName;
  final String eventId;
  final String eventName;
  final String staffId;
  final String staffName;
  final int timestamp;
  final num amount;
  final num lat;
  final num lng;

  TopUp({
    required this.id,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.stationId,
    required this.stationName,
    required this.locationId,
    required this.locationName,
    required this.eventId,
    required this.eventName,
    required this.staffId,
    required this.staffName,
    required this.timestamp,
    required this.amount,
    required this.lat,
    required this.lng,
  });

  // Factory constructor for creating a new instance from a JSON map
  factory TopUp.fromJson(Map<String, dynamic> json) {
    return TopUp(
      id: json['id'],
      balanceBefore: json['balanceBefore'],
      balanceAfter: json['balanceAfter'],
      stationId: json['stationId'],
      stationName: json['stationName'],
      locationId: json['locationId'],
      locationName: json['locationName'],
      eventId: json['eventId'],
      eventName: json['eventName'],
      staffId: json['staffId'],
      staffName: json['staffName'],
      timestamp: json['timestamp'],
      amount: json['amount'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'stationId': stationId,
      'stationName': stationName,
      'locationId': locationId,
      'locationName': locationName,
      'eventId': eventId,
      'eventName': eventName,
      'staffId': staffId,
      'staffName': staffName,
      'timestamp': timestamp,
      'amount': amount,
      'lat': lat,
      'lng': lng,
    };
  }
}
