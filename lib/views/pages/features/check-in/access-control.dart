import 'package:flutter/material.dart';
import 'package:gecko_internal/model/event.dart';
import 'package:gecko_internal/model/location.dart';
import 'package:gecko_internal/model/station.dart';
import 'package:gecko_internal/model/user.dart';
import 'package:gecko_internal/utils/access-control-helper.dart';
import 'package:gecko_internal/utils/nfc-listener.dart';
import 'package:lottie/lottie.dart';

class AccessControlPage extends StatefulWidget {
  final Event event;
  final Location location;
  final StaffUser staffUser;
  final Station station;

  const AccessControlPage(
      {Key? key,
      required this.event,
      required this.location,
      required this.staffUser,
      required this.station})
      : super(key: key);

  @override
  _AccessControlPageState createState() => _AccessControlPageState();
}

class _AccessControlPageState extends State<AccessControlPage> {
  Color backgroundColor =
      const Color.fromARGB(255, 231, 231, 231); // Initial idle state color
  String animationPath =
      'assets/animation/idle.json'; // Initial idle animation path
  bool isVerifying = false;
  final NFCListener nfc = new NFCListener();
  // Access control helper instance
  final AccessControlHelper _accessControlHelper = AccessControlHelper();

  // Function to validate NFC Ticket and update UI based on outcome
  Future<void> validateNfcTicket(String nfcId) async {
    setState(() {
      backgroundColor =
          const Color.fromARGB(255, 125, 168, 233); // Dark blue while verifying
      animationPath = 'assets/animation/verifying.json'; // Verifying animation
      isVerifying = true;
    });

    // Validate NFC Ticket using the helper method
    bool isValid = await _accessControlHelper.validateNfcTicket(
        nfcId, widget.event, widget.location);

    // Update the background and animation based on the result
    setState(() {
      backgroundColor = isValid
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(
              255, 232, 137, 130); // Green if valid, red if invalid
      animationPath = isValid
          ? 'assets/animation/success.json'
          : 'assets/animation/error.json';
      isVerifying = false;
    });
  }

  Future<void> resetScanner() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      isVerifying = false;
    });
    String nfcId = await _scanNfc(); // Replace with your NFC scanning method
    await validateNfcTicket(nfcId);
    resetScanner();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resetScanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: Center(
            child: Lottie.asset(animationPath, // Display the current animation
                width: 300,
                height: 300,
                fit: BoxFit.contain,
                repeat: false)),
      ),
    );
  }

  // Dummy function to simulate NFC scan (replace with actual NFC scan logic)
  Future<String> _scanNfc() async {
    setState(() {
      backgroundColor =
          const Color.fromARGB(255, 235, 235, 235); // Dark blue while verifying
      animationPath = 'assets/animation/idle.json'; // Verifying animation
      isVerifying = false;
    });

    var tag= await nfc.listenForNFCTap();
    return tag;
  }
}
