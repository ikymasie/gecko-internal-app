enum UserRole {
  admin,
  organizer,
  internal,
  vendor,
  attendee,
  staff,
}

enum Permission {
  ManageEvents,
  ManageUsers,
  ManageVendors,
  AccessReports,
  AssignNFCTags,
  AccessControl,
  ProcessTopUps,
  ViewAccessLogs,
}

enum NFCTransactionType {
  Purchase,
  Access,
  TopUp,
  NFCAssignment,
}

enum RSVPStatus {
  Invited,
  Confirmed,
  Declined,
}
