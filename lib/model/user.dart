// User Class
import 'enums.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final bool published;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.published,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role:json['role'],
      published: json['published'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'published': published,
    };
  }
}

// AdminUser Class
class AdminUser extends User {
  final List<String> permissions;

  AdminUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String role,
    required bool published,
    required this.permissions,
  }) : super(id: id, name: name, email: email, phoneNumber: phoneNumber, role: role, published: published);

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      published: json['published'],
      permissions:  List<String>.from(json['permissions']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'published': published,
      'permissions': permissions
    };
  }
}

// OrganizerUser Class
class OrganizerUser extends User {
  final List<String> managedEventIds;
  final List<String> permissions;
  final String accessCode;

  OrganizerUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String role,
    required bool published,
    required this.managedEventIds,
    required this.permissions,
    required this.accessCode,
  }) : super(id: id, name: name, email: email, phoneNumber: phoneNumber, role: role, published: published);

  factory OrganizerUser.fromJson(Map<String, dynamic> json) {
    return OrganizerUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role:json['role'],
      published: json['published'],
      managedEventIds: List<String>.from(json['managedEventIds']),
      permissions:List<String>.from(json['permissions']),
      accessCode: json['accessCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'published': published,
      'managedEventIds': managedEventIds,
      'permissions':permissions,
      'accessCode': accessCode,
    };
  }
}

// VendorUser Class
class VendorUser extends User {
  final String vendorId;
  final String accessCode;

  VendorUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String role,
    required bool published,
    required this.vendorId,
    required this.accessCode,
  }) : super(id: id, name: name, email: email, phoneNumber: phoneNumber, role: role, published: published);

  factory VendorUser.fromJson(Map<String, dynamic> json) {
    return VendorUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      published: json['published'],
      vendorId: json['vendorId'],
      accessCode: json['accessCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'published': published,
      'vendorId': vendorId,
      'accessCode': accessCode,
    };
  }
}

// Additional classes like AttendeeUser, StaffUser, Event, Session, etc. would follow a similar structure.

class AttendeeUser extends User {
  final String? nfcId;
  final List<String>? ticketIds;
  final double balance;

  AttendeeUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String role,
    required bool published,
    this.nfcId,
    this.ticketIds,
    required this.balance,
  }) : super(id: id, name: name, email: email, phoneNumber: phoneNumber, role: role, published: published);

  factory AttendeeUser.fromJson(Map<String, dynamic> json) {
    return AttendeeUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      published: json['published'],
      nfcId: json['nfcId'],
      ticketIds: List<String>.from(json['ticketIds'] ?? []),
      balance: json['balance'].toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'published': published,
      'nfcId': nfcId,
      'ticketIds': ticketIds,
      'balance': balance
    };
  }
}

class StaffUser extends User {
  final String accessCode;
  final List<String> assignedStationIds;
  final List<String> permissions;

  StaffUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String role,
    required bool published,
    required this.accessCode,
    required this.assignedStationIds,
    required this.permissions,
  }) : super(id: id, name: name, email: email, phoneNumber: phoneNumber, role: role, published: published);

  factory StaffUser.fromJson(Map<String, dynamic> json) {
    return StaffUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role:json['role'],
      published: json['published'],
      accessCode: json['accessCode'],
      assignedStationIds: List<String>.from(json['assignedStationIds']),
      permissions:  List<String>.from(json['permissions']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'published': published,
      'accessCode': accessCode,
      'assignedStationIds': assignedStationIds,
      'permissions': permissions,
    };
  }
}
