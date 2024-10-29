import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../model/top-up.dart';

class TopUpReceiptDialog extends StatelessWidget {
  final TopUp topUp;

  TopUpReceiptDialog({
    required this.topUp,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/animation/success.json', // A Lottie animation for top-up success
              height: 100,
            ),
            SizedBox(height: 10),

            // Top-Up Status
            Text(
              'Top-Up Successful',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Divider(thickness: 1.5),

            // Top-Up Details
            _buildTopUpDetail('Reciept:', topUp.id),
            _buildTopUpDetail('Date:', _formatTimestamp(topUp.timestamp)),
            _buildTopUpDetail('Event:', topUp.eventName),
            _buildTopUpDetail('Location:', topUp.locationName),
            _buildTopUpDetail('Station:', topUp.stationName),
            _buildTopUpDetail('Done By:', topUp.staffName),
            _buildTopUpDetail(
                'Top-Up Amount:', 'P${topUp.amount.toStringAsFixed(2)}'),
            _buildTopUpDetail('Balance Before:',
                'P${topUp.balanceBefore.toStringAsFixed(2)}'),
            _buildTopUpDetail(
                'Balance After:', 'P${topUp.balanceAfter.toStringAsFixed(2)}'),

            Divider(thickness: 1.5),
            SizedBox(height: 10),

            // Close Button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each top-up detail row
  Widget _buildTopUpDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Helper method to format the timestamp
  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
