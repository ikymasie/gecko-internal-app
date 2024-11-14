class Ticket {
  final String id;
  final String attendeeId;
  final String ticketTypeId;
  final String eventId;
  final String? nfcId;
  final bool? isCheckedIn;
    final String? checkOutTime;
      final String? checkInTime;
        final num createdAt;
  final num checkedInDuration;
  final num? lastUpdated;
  final String createdBy;

  Ticket({
 required   this.checkOutTime,
 required   this.checkInTime, 
 required    this.checkedInDuration,
    required   this.id,
    required this.attendeeId,
    required this.ticketTypeId,
    required this.eventId,
    required this.nfcId,
    required this.isCheckedIn,
    required this.createdAt,
    required this.lastUpdated,
    required this.createdBy,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      attendeeId: json['attendeeId'],
      ticketTypeId: json['ticketTypeId'],
      eventId: json['eventId'],
      nfcId: json['nfcId'] ?? "",
      isCheckedIn: json['isCheckedIn'] ?? false,
      createdAt: json['createdAt'],
      lastUpdated: json['lastUpdated'] ?? 0,
      createdBy: json['createdBy'],
       checkOutTime:  json['checkOutTime'], 
       checkInTime:  json['checkInTime'], 
       
       checkedInDuration:  json['checkedInDuration'] ?? 0,
       
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendeeId': attendeeId,
      'ticketTypeId': ticketTypeId,
      'eventId': eventId,
      'nfcId': nfcId,
      'isCheckedIn': isCheckedIn,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
      'createdBy': createdBy,
      'checkInTime': checkInTime,
      'checkedInDuration': checkedInDuration,
      'checkOutTime': checkOutTime,

    };
  }
}
