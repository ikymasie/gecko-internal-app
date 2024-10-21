import 'enums.dart';

class Coordinates {
  final double lat;
  final double lng;
  final double bearing;

  Coordinates({
    required this.lat,
    required this.lng,
    required this.bearing,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'],
      lng: json['lng'],
      bearing: json['bearing'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'bearing': bearing,
    };
  }
}


class PurchaseDetails {
  final List<PurchaseItem> items;
  final double totalAmount;
  final String vendorId;

  PurchaseDetails({
    required this.items,
    required this.totalAmount,
    required this.vendorId,
  });

  factory PurchaseDetails.fromJson(Map<String, dynamic> json) {
    return PurchaseDetails(
      items: (json['items'] as List).map((e) => PurchaseItem.fromJson(e)).toList(),
      totalAmount: json['totalAmount'].toDouble(),
      vendorId: json['vendorId'],
    );
  }

  

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'vendorId': vendorId,
    };
  }
}


class PurchaseItem {
  final String itemId;
  final int quantity;
  final double price;

  PurchaseItem({
    required this.itemId,
    required this.quantity,
    required this.price,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      itemId: json['itemId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'price': price,
    };
  }
}

class AccessDetails {
  final String accessLevelId;
  final String locationId;
  final String checkpointId;

  AccessDetails({
    required this.accessLevelId,
    required this.locationId,
    required this.checkpointId,
  });

  factory AccessDetails.fromJson(Map<String, dynamic> json) {
    return AccessDetails(
      accessLevelId: json['accessLevelId'],
      locationId: json['locationId'],
      checkpointId: json['checkpointId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessLevelId': accessLevelId,
      'locationId': locationId,
      'checkpointId': checkpointId,
    };
  }
}

class TopUpDetails {
  final double amount;
  final String staffId;

  TopUpDetails({
    required this.amount,
    required this.staffId,
  });

  factory TopUpDetails.fromJson(Map<String, dynamic> json) {
    return TopUpDetails(
      amount: json['amount'].toDouble(),
      staffId: json['staffId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'staffId': staffId,
    };
  }
}

class Invoice {
  final String id;
  final String attendeeId;
  final String purchaseTransactionId;
  final double totalAmount;
  final DateTime date;

  Invoice({
    required this.id,
    required this.attendeeId,
    required this.purchaseTransactionId,
    required this.totalAmount,
    required this.date,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      attendeeId: json['attendeeId'],
      purchaseTransactionId: json['purchaseTransactionId'],
      totalAmount: json['totalAmount'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendeeId': attendeeId,
      'purchaseTransactionId': purchaseTransactionId,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
    };
  }
}

class NFCTransaction<T> {
  final String id;
  final String nfcId;
  final NFCTransactionType type;
  final DateTime timestamp;
  final Coordinates? location;
  final T details;

  NFCTransaction({
    required this.id,
    required this.nfcId,
    required this.type,
    required this.timestamp,
    this.location,
    required this.details,
  });

  factory NFCTransaction.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromDetailsJson) {
    return NFCTransaction(
      id: json['id'],
      nfcId: json['nfcId'],
      type: NFCTransactionType.values.byName(json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      location: json['location'] != null ? Coordinates.fromJson(json['location']) : null,
      details: fromDetailsJson(json['details']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toDetailsJson) {
    return {
      'id': id,
      'nfcId': nfcId,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'location': location?.toJson(),
      'details': toDetailsJson(details),
    };
  }
}
