import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gecko_internal/model/event.dart';
import 'package:gecko_internal/model/location.dart';
import 'package:gecko_internal/model/ticket-type.dart';
import 'package:gecko_internal/model/ticket.dart';

class AccessControlHelper {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch a Ticket by NFC ID
 Future<bool> validateNfcTicket(
    String nfcId, Event event, Location location) async {
  Ticket? ticket;
  TicketType? type;
  bool grantAccess = false;

  try {
    CollectionReference ticketsCollection = _firestore.collection('tickets');

    QuerySnapshot querySnapshot = await ticketsCollection
        .where('nfcId', isEqualTo: nfcId)
        .where('eventId', isEqualTo: event.id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> ticketData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      ticket = Ticket.fromJson(ticketData);

      // Check if the ticket is already checked in
      if (ticket.isCheckedIn!) {
        print('Ticket already used for entry');
        throw 'Ticket already used for entry';
      }
    }

    if (ticket != null) {
      for (var t in event.ticketTypes!) {
        if (t.id == ticket.ticketTypeId) {
          type = t;
          break;
        }
      }

      if (type != null) {
        for (var level in location.accessLevelIds) {
          for (var userAllowed in type.accessLevelIds) {
            if (userAllowed == level) {
              grantAccess = true;
              break;
            }
          }
        }

        if (grantAccess) {
          // Update the ticket's check-in status and check-in time
          await ticketsCollection.doc(querySnapshot.docs.first.id).update({
            'isCheckedIn': true,
            'checkInTime': DateTime.now().toIso8601String()
          });
        }
        
      } else {
        print('No ticket type found');
        throw 'No ticket type found';
      }
    } else {
      print('Invalid Tag for Event');
      throw 'Invalid Tag for Event';
    }

    return grantAccess;
  } catch (e) {
    print('Error fetching ticket by NFC ID: $e');
    throw e;
  }
}

Future<void> checkoutTicket(String nfcId, Event event) async {
  try {
    CollectionReference ticketsCollection = _firestore.collection('tickets');

    QuerySnapshot querySnapshot = await ticketsCollection
        .where('nfcId', isEqualTo: nfcId)
        .where('eventId', isEqualTo: event.id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot ticketDoc = querySnapshot.docs.first;
      Map<String, dynamic> ticketData = ticketDoc.data() as Map<String, dynamic>;

      if (ticketData['isCheckedIn'] == true) {
        // Record the check-out time
        DateTime checkOutTime = DateTime.now();
        DateTime checkInTime = DateTime.parse(ticketData['checkInTime']);
        Duration checkedInDuration = checkOutTime.difference(checkInTime);

        await ticketsCollection.doc(ticketDoc.id).update({
          'isCheckedIn': false,
          'checkOutTime': checkOutTime.toIso8601String(),
          'checkedInDuration': checkedInDuration.inMinutes
        });

        print('Ticket successfully checked out');
      } else {
        print('Ticket is not currently checked in');
        throw 'Ticket is not currently checked in';
      }
    } else {
      print('Invalid NFC ID or Event ID');
      throw 'Invalid NFC ID or Event ID';
    }
  } catch (e) {
    print('Error during checkout: $e');
    throw e;
  }
}

}
