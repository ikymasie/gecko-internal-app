import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/nfc-transaction.dart';
import '../model/ticket-type.dart';
import '../model/top-up.dart';
import '../model/user.dart';

class StaffApi {
  final String baseUrl = "https://gecko-api-c78d4e2345c5.herokuapp.com";

  StaffApi();

  // Fetch attendee by phone number and cast to AttendeeUser
  Future<AttendeeUser> getAttendeeByPhoneNumber(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/staff/attendee/phone/$phoneNumber');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return AttendeeUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load attendee by phone number');
    }
  }

  // Fetch attendee by NFC tag and cast to AttendeeUser
  Future<AttendeeUser> getAttendeeByTag(String nfcId) async {
    final url = Uri.parse('$baseUrl/staff/attendee/tag/$nfcId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return AttendeeUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load attendee by NFC tag');
    }
  }

  // Process a top-up with the relevant details (no return expected)
  // Process a top-up and return the TopUp response
  Future<TopUp> processTopUp({
    required String staffId,
    required String staffName,
    required String eventId,
    required String eventName,
    required String locationId,
    required String nfcId,
    required String locationName,
    required String stationId,
    required String stationName,
    required double amount,
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('$baseUrl/staff/top-up');

    // Creating the JSON body with the individual parameters
    final body = {
      'staffId': staffId,
      'staffName': staffName,
      'eventId': eventId,
      'eventName': eventName,
      'locationId': locationId,
      'nfcId': nfcId,
      'locationName': locationName,
      'stationId': stationId,
      'stationName': stationName,
      'amount': amount,
      'lat': lat,
      'lng': lng,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Assuming that the `data` field contains the TopUp information
      if (responseData['data'] != null) {
        return TopUp.fromJson(responseData['data']);
      } else {
        throw Exception('Top-up data not found in response');
      }
    } else {
      throw Exception('Failed to process top-up');
    }
  }

  // Validate access for an attendee and cast response into a map
  Future<AccessDetails> validateAccess(AccessDetails validationData) async {
    final url = Uri.parse('$baseUrl/staff/validate-access');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(validationData.toJson()),
    );
    if (response.statusCode == 200) {
      return AccessDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to validate access');
    }
  }

  // Get ticket types for an event and cast to List<TicketType>
  Future<List<TicketType>> getTicketTypes(String eventId) async {
    final url = Uri.parse('$baseUrl/staff/event/$eventId/ticket-types');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> ticketTypesJson = jsonDecode(response.body)['ticketTypes'];
      return ticketTypesJson.map((e) => TicketType.fromJson(e)).toList();
    } else {
      throw Exception('Failed to retrieve ticket types');
    }
  }

  // Create a ticket for an attendee
  Future<Map<String, dynamic>> createTicketForAttendee(
      Map<String, dynamic> ticketData) async {
    final url = Uri.parse('$baseUrl/staff/ticket/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ticketData),
    );
    var item = jsonDecode(response.body);
    print('${item['data']}');
    if (item["success"] == false) {
      throw Exception('Failed to create ticket for attendee');
    } else {
      return item['data'];
    }
  }

  // Link an NFC tag to an attendee
  Future<void> linkNFCTagToAttendee(
      String userId, String nfcId, String ticketId, String staffId) async {
    final data = {
      "userId": userId,
      "staffId": staffId,
      "nfcId": nfcId,
      "ticketId": ticketId
    };
    final url = Uri.parse('$baseUrl/staff/nfc/link');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    var rsp = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to link NFC tag to attendee');
    }
  }
}
