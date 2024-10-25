import 'package:flutter/material.dart';
import 'package:gecko_internal/services/staff-api.dart';
import 'package:gecko_internal/model/user.dart';
import 'package:gecko_internal/utils/global-loader.dart';
import 'package:gecko_internal/model/nfc-transaction.dart'; // Fixed missing quote

class TopUpPage extends StatefulWidget {
  final StaffUser staffUser;

  TopUpPage({required this.staffUser});

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final GlobalLoader loader = GlobalLoader();
  final StaffApi api = StaffApi();

  void _topUp() async {
    String phoneNumber = _phoneController.text.trim();
    double amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (phoneNumber.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid phone number and amount.')),
      );
      return;
    }

    loader.showLoader(context, message: 'Processing top-up...');

    try {
      // Fetch attendee by phone number
      AttendeeUser attendee = await api.getAttendeeByPhoneNumber(phoneNumber);

      // Create top-up details
      TopUpDetails topUpDetails =
          TopUpDetails(amount: amount, staffId: widget.staffUser.id);

      // Process the top-up
      await api.processTopUp(topUpDetails);
      loader.hideLoader();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Top-up successful for ${attendee.name}')),
      );

      // Clear the input fields
      _phoneController.clear();
      _amountController.clear();
    } catch (e) {
      loader.hideLoader();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing top-up: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up Attendee Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Attendee Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount to Top Up',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _topUp,
              child: Text('Top Up'),
            ),
          ],
        ),
      ),
    );
  }
}
