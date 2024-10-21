import 'ticket-type.dart';

class Event {
  final String id;
  final String? externalEventId;
  final String name;
  final bool published;
  final String? description;
  final String? externalPlatform;
  final String? externalUrl;
  final Schedule schedule;
  final List<TicketType>? ticketTypes;
  final List<String> accessLevelIds;
  final List<String> locationIds;
  final bool isRSVPEvent;

  Event({
    required this.id,
    this.externalEventId,
    required this.name,
    required this.published,
    this.description,
    this.externalPlatform,
    this.externalUrl,
    required this.schedule,
    this.ticketTypes,
    required this.accessLevelIds,
    required this.locationIds,
    required this.isRSVPEvent,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      externalEventId: json['externalEventId'],
      name: json['name'],
      published: json['published'],
      description: json['description'],
      externalPlatform: json['externalPlatform'],
      externalUrl: json['externalUrl'],
      schedule: Schedule.fromJson(json['schedule']),
      ticketTypes: (json['ticketTypes'] as List?)?.map((e) => TicketType.fromJson(e)).toList(),
      accessLevelIds: List<String>.from(json['accessLevelIds'] ??[]),
      locationIds: List<String>.from(json['locationIds'] ??[]),
      isRSVPEvent: json['isRSVPEvent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'externalEventId': externalEventId,
      'name': name,
      'published': published,
      'description': description,
      'externalPlatform': externalPlatform,
      'externalUrl': externalUrl,
      'schedule': schedule.toJson(),
      'ticketTypes': ticketTypes?.map((e) => e.toJson()).toList(),
      'accessLevelIds': accessLevelIds,
      'locationIds': locationIds,
      'isRSVPEvent': isRSVPEvent,
    };
  }
}

class Schedule {
  final List<ScheduleDate> dates;

  Schedule({
    required this.dates,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      dates: (json['dates'] as List).map((e) => ScheduleDate.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dates': dates.map((e) => e.toJson()).toList(),
    };
  }
}

class ScheduleDate {
  final String startDate;
  final String endDate;
  final List<String>? sessionIds;

  ScheduleDate({
    required this.startDate,
    required this.endDate,
    this.sessionIds,
  });

  factory ScheduleDate.fromJson(Map<String, dynamic> json) {
    return ScheduleDate(
      startDate: json['startDate'],
      endDate: json['endDate'],
      sessionIds: List<String>.from(json['sessionIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'sessionIds': sessionIds,
    };
  }
}

