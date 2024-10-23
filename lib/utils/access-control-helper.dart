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
      // Access the 'tickets' collection in Firestore
      CollectionReference ticketsCollection = _firestore.collection('tickets');

      // Query Firestore for a document where the 'nfcId' matches the provided value
      QuerySnapshot querySnapshot = await ticketsCollection
          .where('nfcId', isEqualTo: nfcId)
          .where('eventId', isEqualTo: event.id)
          .limit(1)
          .get();

      // If a matching document is found, return the corresponding Ticket
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> ticketData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        ticket = Ticket.fromJson(ticketData); // Convert to Ticket object
      }

      if (ticket != null) {
        // get ticket type
        for (var i = 0; i < event.ticketTypes!.length; i++) {
          var t = event.ticketTypes![i];
          if (t.id == ticket.ticketTypeId) {
            type = t;
            break;
          }
        }
        if (type != null) {
          for (var i = 0; i < location.accessLevelIds.length; i++) {
            var level = location.accessLevelIds[i];
            for(var x =0;x<type.accessLevelIds.length;x++){
              var userAllowed = type.accessLevelIds[x];
              if(userAllowed==level){
                grantAccess=true;
                break;
              }
            }
          }
        }else{
          print(' NO ticket type found');
        }
      }else{
          print('INVALID TAG FOR EVENT');
      }

      // If no ticket is found, return null
      return grantAccess;
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error fetching ticket by NFC ID: $e');
      return grantAccess;
    }
  }

}
