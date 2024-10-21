import 'package:flutter/material.dart';
import 'package:gecko_internal/model/ticket-type.dart';
import 'package:gecko_internal/model/user.dart';
import 'package:gecko_internal/services/admin-api.dart';
import 'package:lottie/lottie.dart';

class UserSearchBottomSheet extends StatefulWidget {
  final TicketType ticketToLoad;
  final Function() onCreateAttendee;
  final Function(AttendeeUser user) onAttendeeSelected;
  UserSearchBottomSheet(
      {required this.ticketToLoad,
      required this.onCreateAttendee,
      required this.onAttendeeSelected});

  @override
  _UserSearchBottomSheetState createState() => _UserSearchBottomSheetState();
}

class _UserSearchBottomSheetState extends State<UserSearchBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _userFound = false;
  dynamic _userData; // Store user data if found
  String? _errorMessage;

  // Method to search user by email
  Future<void> _searchUserByEmail() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _userFound = false;
      _userData = null;
      _errorMessage = null;
    });

    try {
      // Replace AttendeeUser with the type you expect (AdminUser, VendorUser, etc.)
      final result = await AdminApi()
          .getAccountByEmail<AttendeeUser>(_emailController.text);
      setState(() {
        _userData = result;
        _userFound = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _userFound = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  onSubmitted: (val){
                    _searchUserByEmail();
                  },
                  decoration: InputDecoration(
                    labelText:
                        "Find ${widget.ticketToLoad.name} Attendee by Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _searchUserByEmail, // Trigger search
              ),
            ],
          ),
          SizedBox(height: 20),

          // Loading animation
          if (_isLoading)
            Lottie.asset('assets/animation/loading.json', height: 150),

          // Error message display
          if (_errorMessage != null)
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),

          // If user found, show details and Assign Tag button
          if (_userFound && _userData != null) ...[
            // User details header
            Lottie.asset('assets/animation/success.json',
                height: 100, repeat: false),
            SizedBox(height: 10),
            Text(
              "User Found",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            // User details
            Text(
              "${_userData.name} ", // Assuming _userData has name and email
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              "${_userData.email} | WhatsApp: ${_userData.phoneNumber ?? 'Not found'}", // Assuming _userData has name and email
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Text(
              "Account Type: Attendee", // Adjust based on account type
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
            SizedBox(height: 20),

            // Assign Tag button
            ElevatedButton(
              onPressed: () {
                // Handle assigning tag
                widget.onAttendeeSelected(_userData);
              },
              child: Text("Assign Tag"),
            ),
          ],

          // If no user found, show Create Attendee button
          if (!_userFound && !_isLoading && _errorMessage == null) ...[
            Lottie.asset('assets/animation/error.json',
                height: 150, repeat: false),
            SizedBox(height: 20),
            Text(
              "No account found for this email.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle creating new attendee
                widget.onCreateAttendee();
              },
              child: Text("Create New Attendee"),
            ),
          ],
        ],
      ),
    );
  }
}
