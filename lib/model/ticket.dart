class Ticket {
  final String id;
  final String attendeeId;
  final String ticketTypeId;
  final String eventId;
   final String? nfcId;
  final num createdAt;
  final String createdBy;

  Ticket({
    required this.id,
    required this.attendeeId,
    required this.ticketTypeId,
    required this.eventId,
     required this.nfcId,
    required this.createdAt,
    required this.createdBy,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      attendeeId: json['attendeeId'],
      ticketTypeId: json['ticketTypeId'],
      eventId: json['eventId'],
        nfcId: json['nfcId'] ??"",
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendeeId': attendeeId,
      'ticketTypeId': ticketTypeId,
      'eventId': eventId,
      'nfcId':nfcId,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
