import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:gecko_internal/utils/global-loader.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../model/event.dart';
import '../../../../model/location.dart';
import '../../../../model/station.dart';
import '../../../../model/top-up.dart';
import '../../../../model/user.dart';
import '../../../../services/staff-api.dart';
import '../../../widgets/nfc-listening-dialog.dart';
import 'top-up-receipt.dart';

class TopUpPage extends StatefulWidget {
  final AdminUser adminUser;
  final StaffUser staffUser;
  final Event event;
  final Location location;
  final Station station;

  TopUpPage({
    required this.adminUser,
    required this.event,
    required this.location,
    required this.station,
    required this.staffUser,
  });

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  String _inputAmount = '';
  Position? _currentPosition;
  final StaffApi _staffApi = StaffApi();
  final loader = new GlobalLoader();
  AnimatedDigitController controller = AnimatedDigitController(0);

  // Function to update the input amount like a POS calculator
  void _updateAmount(String digit) {
    setState(() {
      // Handle "Clear" functionality
      if (digit == 'C') {
        _inputAmount = '';
        controller.value = 0;
      }
      // Handle "Backspace" functionality
      else if (digit == '←') {
        if (_inputAmount.isNotEmpty) {
          _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        }
      }
      // Handle decimal input, allowing only one decimal point
      else if (digit == '.' && !_inputAmount.contains('.')) {
        _inputAmount += digit;
      }
      // Append digit if it is not a decimal point or backspace
      else if (RegExp(r'^\d$').hasMatch(digit)) {
        _inputAmount += digit;
      }
      // Update display using NumberTicker
      controller.value = double.tryParse(_inputAmount) ?? 0;
    });
  }

  // Fetch the current geolocation
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      print("Location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Error getting location: $e");
    }
  }
   scanTag() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return NFCListeningDialog(
          instruction: "Please tap your NFC load ticket",
          onTapComplete: (String nfcId) {
             _handleTopUp(nfcId);
          },
        );
      },
    ).then((tagId) {
      if (tagId != null) {
        // Handle the NFC tag ID here
        print('NFC Tag ID: $tagId');
      }
    });
  }

  // Function to handle top-up
  Future<void> _handleTopUp(String nfcId) async {
    loader.showLoader(context,message: 'Tap to load balance');
    try{
    await _getCurrentLocation();
    if (_inputAmount.isEmpty || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an amount and enable location')),
      );
      return;
    }

    double amount = double.tryParse(_inputAmount) ?? 0.0;

    // Call the StaffApi for top-up
    TopUp? topUp = await _staffApi.processTopUp(
      staffId: widget.staffUser.id,
      staffName: widget.staffUser.name,
      eventId: widget.event.id,
      eventName: widget.event.name,
      locationId: widget.location.id,
      locationName: widget.location.name,
      stationId: widget.station.id,
      stationName: widget.station.name!,
      nfcId: nfcId,
      amount: amount,
      lat: _currentPosition!.latitude,
      lng: _currentPosition!.longitude,
    );
      loader.hideLoader();

    // Show the receipt dialog with top-up details
    showDialog(
      context: context,
      builder: (context) {
        return TopUpReceiptDialog(topUp: topUp);
      },
    );
    setState(() {
      _inputAmount = ''; // Clear the input amount after top-up
      controller.value = 0; // Reset the display
    });
    }catch(e){
      loader.hideLoader();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process top-up: $e')),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top-Up'),
      ),
      body: Column(
        children: [
          // Display input amount
          Expanded(
            flex: 1 ,
            child: Center(
              child: AnimatedDigitWidget(
                controller: controller,
                fractionDigits: 2,
                decimalSeparator: '.',
                loop: false,
                animateAutoSize: true,
                autoSize: true,
                duration: Duration(milliseconds: 500),
                textStyle: TextStyle(fontSize: 78, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Keypad for entering top-up amount
          Expanded(
            flex: 4,
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(8.0),
              children: [
                ...[
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '.',
                  '0',
                  'C',
                  '←'
                ].map((digit) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () => _updateAmount(digit),
                      child: Text(digit, style: TextStyle(fontSize: 24)),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Top-Up Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:scanTag,
              child: Text('Top-Up', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
