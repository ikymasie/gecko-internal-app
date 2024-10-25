import 'package:flutter/material.dart';
import 'package:gecko_internal/services/staff-api.dart';
import 'package:gecko_internal/model/user.dart';
import 'package:gecko_internal/utils/global-loader.dart';
import 'package:gecko_internal/utils/nfc-listener.dart';
import 'package:gecko_internal/model/nfc-transaction.dart'; // Ensure this path is correct

class TopUpPage extends StatefulWidget {
  final StaffUser staffUser;

  TopUpPage({required this.staffUser});

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalLoader loader = GlobalLoader();
  final StaffApi api = StaffApi();
  final NFCListener _nfcListener = NFCListener(); // NFC listener instance
  String? _attendeeId;

  void _topUp() async {
    if (_attendeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please tap an NFC tag to select an attendee.')),
      );
      return;
    }

    double amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    loader.showLoader(context, message: 'Processing top-up...');

    try {
      // Create top-up details
      TopUpDetails topUpDetails =
          TopUpDetails(amount: amount, staffId: widget.staffUser.id);

      // Process the top-up
      await api.processTopUp(topUpDetails);

      loader.hideLoader();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Top-up successful for attendee ID: $_attendeeId')),
      );

      // Clear the input fields
      _amountController.clear();
      _attendeeId = null; // Reset attendee ID
    } catch (e) {
      loader.hideLoader();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _startNFCListening() {
    _nfcListener.startListening((String nfcId) async {
      // Fetch attendee by NFC ID
      try {
        AttendeeUser attendee = await api.getAttendeeByNfcId(nfcId);
        setState(() {
          _attendeeId = attendee.id; // Set the attendee ID
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendee verified: ${attendee.name}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching attendee: $e')),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startNFCListening(); // Start listening for NFC tags
  }

  @override
  void dispose() {
    _nfcListener.stopListening(); // Stop listening when the widget is disposed
    super.dispose();
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
            Text(
              _attendeeId != null
                  ? 'Attendee ID: $_attendeeId'
                  : 'Tap NFC tag to select attendee',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
