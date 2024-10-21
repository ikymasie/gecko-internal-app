
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/event.dart';
import '../model/location.dart';
import '../model/station.dart';
import '../model/user.dart';

class AdminApi {
  final String baseUrl="https://343e-168-167-81-94.ngrok-free.app";

  AdminApi();
 
  Future<AttendeeUser> createAttendee(String name, String phone, String email) async {
    final url = Uri.parse('$baseUrl/admin/accounts');
  var data = {
    "name":name,
    "email":email,
    "phoneNumber":phone,
    "role":"attendee",
    "nfcId":""
  };
    try {
      final response = await http.post(url,body:data);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check if the success flag is true
        if (jsonResponse['success']) {
           return AttendeeUser.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['errorMessage'] ?? 'Failed to fetch account');
        }
      } else {
        throw Exception('Failed to load account, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching account: $e');
    }
  }


  Future<T> getAccountById<T>(String accountId) async {
    final url = Uri.parse('$baseUrl/admin/accounts/$accountId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check if the success flag is true
        if (jsonResponse['success']) {
          // Automatically cast the response data to the correct type
          if (T == AdminUser) {
            return AdminUser.fromJson(jsonResponse['data']) as T;
          } else if (T == OrganizerUser) {
            return OrganizerUser.fromJson(jsonResponse['data']) as T;
          } else if (T == VendorUser) {
            return VendorUser.fromJson(jsonResponse['data']) as T;
          } else if (T == AttendeeUser) {
            return AttendeeUser.fromJson(jsonResponse['data']) as T;
          } else if (T == StaffUser) {
            return StaffUser.fromJson(jsonResponse['data']) as T;
          } else {
            throw Exception('Unsupported type');
          }
        } else {
          throw Exception(jsonResponse['errorMessage'] ?? 'Failed to fetch account');
        }
      } else {
        throw Exception('Failed to load account, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching account: $e');
    }
  }

   Future<T> getAccountByEmail<T>(String email) async {
    final url = Uri.parse('$baseUrl/admin/accounts/email/$email');
  
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check if the success flag is true
        if (jsonResponse['success']) {
          // Automatically cast the response data to the correct type
          if (T == AdminUser) {
            return AdminUser.fromJson(jsonResponse['data']) as T;
          } else if (T == OrganizerUser) {
            return OrganizerUser.fromJson(jsonResponse['data']) as T;
          } else if (T == VendorUser) {
            return VendorUser.fromJson(jsonResponse['data']) as T;
          } else if (T == AttendeeUser) {
            return AttendeeUser.fromJson(jsonResponse['data']) as T;
          } else if (T == StaffUser) {
            return StaffUser.fromJson(jsonResponse['data']) as T;
          } else {
            throw Exception('Unsupported type');
          }
        } else {
          throw Exception(jsonResponse['errorMessage'] ?? 'Failed to fetch account');
        }
      } else {
        throw Exception('Failed to load account, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching account: $e');
    }
  }
  
  
  // Fetch all events
 Future<List<Event>> getAllEvents() async {
  final url = Uri.parse('$baseUrl/admin/events');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Check if the success flag is true
      if (jsonResponse['success']) {
        // Parse the 'data' field into a list of Event objects
        List<dynamic> eventsJson = jsonResponse['data'];
        return eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      } else {
        throw Exception(jsonResponse['errorMessage'] ?? 'Failed to fetch events');
      }
    } else {
      throw Exception('Failed to load events, Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching events: $e');
  }
}
  // Fetch locations for a specific event
  Future<List<Location>> getLocationForEvent(String eventId) async {
    final url = Uri.parse('$baseUrl/admin/locations/event/$eventId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check if the success flag is true
        if (jsonResponse['success']) {
          // Parse the 'data' field into a list of Location objects
          List<dynamic> locationsJson = jsonResponse['data'];
          return locationsJson.map((locationJson) => Location.fromJson(locationJson)).toList();
        } else {
          throw Exception(jsonResponse['errorMessage'] ?? 'Failed to fetch locations for event');
        }
      } else {
        throw Exception('Failed to load locations, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }

Future<List<Station>> getStationsByLocation(String locationId) async {

    final url = Uri.parse('$baseUrl/admin/stations/location/$locationId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check if the success flag is true
        if (jsonResponse['success']) {
          // Parse the 'data' field into a list of Station objects
          List<dynamic> stationsJson = jsonResponse['data'];
          return stationsJson.map((stationJson) => Station.fromJson(stationJson)).toList();
        } else {
          throw Exception(jsonResponse['errorMessage'] ?? 'Failed to fetch stations for location');
        }
      } else {
        throw Exception('Failed to load stations, Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stations: $e');
    }
  }

}
