import 'station_type.dart';

class Station {
  final String id;
  final String eventId;
  final StationType type;
  final String? name;
  final String locationId;
  final bool isActive;
  final List<String> staffIds;

  Station({
    required this.id,
    required this.eventId,
    required this.type,
    this.name,
    required this.locationId,
    required this.isActive,
    required this.staffIds,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      eventId: json['eventId'],
      type: StationType.values
          .firstWhere((e) => e.toString() == 'StationType.${json['type']}'),
      name: json['name'],
      locationId: json['locationId'],
      isActive: json['isActive'],
      staffIds: List<String>.from(json['staffIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'type': type.toString().split('.').last,
      'name': name,
      'locationId': locationId,
      'isActive': isActive,
      'staffIds': staffIds,
    };
  }
}
