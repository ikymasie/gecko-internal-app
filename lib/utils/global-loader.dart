// ignore_for_file: prefer_final_fields, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GlobalLoader {
  static final GlobalLoader _instance = GlobalLoader._internal();

  factory GlobalLoader() => _instance;

  GlobalLoader._internal();

  OverlayEntry? _overlayEntry;
  String? _currentMessage; // To keep track of the current message
  String _defaultLottieAsset =
      'assets/animation/loading.json'; // Default Lottie animation

  // Method to show the loader with a specific Lottie animation and an optional message
  void showLoader(BuildContext context,
      {String? lottieAsset, String? message, Color? backgroundColor}) {
    if (_overlayEntry != null) return; // Prevent showing multiple loaders

    _currentMessage = message; // Set the initial message

    // Create an OverlayEntry that will display the loader
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Optional background color to darken the screen
          if (backgroundColor != null)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: backgroundColor.withOpacity(0.8),
            ),
          if (backgroundColor == null)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white.withOpacity(0.8),
            ),

          // Center the Lottie animation and message
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  lottieAsset ??
                      _defaultLottieAsset, // Use provided animation or default one
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                if (_currentMessage !=
                    null) // If a message is provided, show it
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _currentMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 35, 25, 25),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    // Insert the overlay into the Overlay of the current context
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Method to hide the loader
  void hideLoader() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentMessage = null; // Reset the message
  }

  // Method to update the message while the loader is still visible
  void updateMessage(String newMessage) {
    if (_overlayEntry != null) {
      _currentMessage = newMessage; // Update the current message

      // Rebuild the overlay to reflect the new message
      _overlayEntry!.markNeedsBuild();
    }
  }
}
