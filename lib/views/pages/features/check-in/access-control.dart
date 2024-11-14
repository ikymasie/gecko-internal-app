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
  Color backgroundColor = const Color.fromARGB(255, 231, 231, 231);
  String animationPath = 'assets/animation/idle.json';
  bool isVerifying = false;
  String scanMessage = ''; // Message to show scan result
  bool isCheckOut = false;
  final NFCListener nfc = NFCListener();
  final AccessControlHelper _accessControlHelper = AccessControlHelper();

  Future<void> validateNfcTicket(String nfcId) async {
    setState(() {
      backgroundColor = const Color.fromARGB(255, 125, 168, 233);
      animationPath = 'assets/animation/verifying.json';
      isVerifying = true;
      scanMessage = 'Verifying...'; // Show verifying message
    });
    bool isValid = false;
    try {
      if (isCheckOut) {
        // checkout stattion
        await _accessControlHelper.checkoutTicket(nfcId, widget.event);
        isValid = true;
      } else {
        isValid = await _accessControlHelper.validateNfcTicket(
            nfcId, widget.event, widget.location);
                setState(() {
      backgroundColor = isValid
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 232, 137, 130);
      animationPath = isValid
          ? 'assets/animation/success.json'
          : 'assets/animation/error.json';
      isVerifying = false;
      scanMessage = isValid ? 'Access Granted' : 'Access Denied';
    });
      }
    } catch (e) {
      setState(() {
              backgroundColor = isValid
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 232, 137, 130);
                animationPath = isValid
          ? 'assets/animation/success.json'
          : 'assets/animation/error.json';
        isValid = false;
        isVerifying = false;
        scanMessage = '$e';
      });
    }


  }

  Future<void> resetScanner() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      isVerifying = false;
    });
    String nfcId = await _scanNfc();

    await validateNfcTicket(nfcId);
    resetScanner();
  }

  @override
  void initState() {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                  value: isCheckOut,
                  onChanged: (val) {

                    setState(() {
                      isCheckOut = val;
                    });
                  }),
              Text('Access Type: '+ (isCheckOut ? 'Check Out' : 'Check In'),
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text(widget.location.name,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Lottie.asset(
                animationPath,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
                repeat: false,
              ),
              SizedBox(height: 20),
              Text(
                scanMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isVerifying
                      ? Colors.grey
                      : (scanMessage == 'Access Granted'
                          ? Colors.green
                          : Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _scanNfc() async {
    setState(() {
      backgroundColor = const Color.fromARGB(255, 235, 235, 235);
      animationPath = 'assets/animation/idle.json';
      isVerifying = false;
      scanMessage = 'Ready to scan...';
    });

    var tag = await nfc.listenForNFCTap();
    return tag;
  }
}
