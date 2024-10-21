class NFCAssignment {
  final String id;
  final String attendeeId;
  final String nfcId;
  final String assignedByStaffId;
  final DateTime timestamp;

  NFCAssignment({
    required this.id,
    required this.attendeeId,
    required this.nfcId,
    required this.assignedByStaffId,
    required this.timestamp,
  });

  factory NFCAssignment.fromJson(Map<String, dynamic> json) {
    return NFCAssignment(
      id: json['id'],
      attendeeId: json['attendeeId'],
      nfcId: json['nfcId'],
      assignedByStaffId: json['assignedByStaffId'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendeeId': attendeeId,
      'nfcId': nfcId,
      'assignedByStaffId': assignedByStaffId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
