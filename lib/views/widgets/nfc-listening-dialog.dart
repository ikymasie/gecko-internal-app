import 'package:flutter/material.dart';
import 'package:gecko_internal/utils/nfc-listener.dart';
import 'package:lottie/lottie.dart';
 
class NFCListeningDialog extends StatefulWidget {
  final String instruction;
  final Function(String nfcId) onTapComplete;

  NFCListeningDialog({required this.instruction, required this.onTapComplete});

  @override
  _NFCListeningDialogState createState() => _NFCListeningDialogState();
}

class _NFCListeningDialogState extends State<NFCListeningDialog> {
  bool _isListening = false;
  String? _tagId;
  String? _errorMessage;

  final NFCListener _nfcListener = NFCListener(); // NFC listener instance

  @override
  void initState() {
    super.initState();
    _startNFCListening();
  }

  // Function to start NFC listening
  Future<void> _startNFCListening() async {
    setState(() {
      _isListening = true;
      _errorMessage = null;
    });

    try {
      String tagId = await _nfcListener.listenForNFCTap();
      setState(() {
        _isListening = false;
        _tagId = tagId; // Save the detected NFC tag ID
      });
      widget.onTapComplete(tagId);
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _isListening = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Instruction Text
            Text(
              widget.instruction,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // NFC Tag Listening Animation
            if (_isListening)
              Lottie.asset('assets/animation/nfc-tap.json', height: 250),
            
            // Show detected NFC tag ID if available
            if (_tagId != null)
              Column(
                children: [
                  Text(
                    "NFC Tag Detected",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tag ID: $_tagId",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_tagId); // Return the tag ID and close dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              ),

            // Show error message if any
            if (_errorMessage != null)
              Column(
                children: [
                  Text(
                    "Error",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog on error
                    },
                    child: Text("Close"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
