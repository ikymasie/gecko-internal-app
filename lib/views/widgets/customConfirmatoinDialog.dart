import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String lottieAsset;
  final bool dismissOnTapOutside;
  final VoidCallback onConfirm; // Callback for Confirm action
  final VoidCallback onCancel;  // Callback for Cancel action

  ConfirmationDialog({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.onConfirm,  // Pass confirmation action
    required this.onCancel,   // Pass cancel action
    this.dismissOnTapOutside = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            Lottie.asset(
              lottieAsset,
              height: 150,
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Confirm and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onCancel(); // Call the cancel callback
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Cancel button color
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    onConfirm(); // Call the confirm callback
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
