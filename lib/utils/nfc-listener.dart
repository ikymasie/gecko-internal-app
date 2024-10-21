import 'package:nfc_manager/nfc_manager.dart';

class NFCListener {
  // Function to listen for NFC tag taps and return the ID
  Future<String> listenForNFCTap() async {
    try {
      // Check if NFC is available and enabled on the device
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        throw Exception('NFC is not available or enabled on this device.');
      }

      String? tagId;

      String lastTagId = "";

      // Start listening for NFC tags
      await NfcManager.instance.startSession(
        invalidateAfterFirstRead: false,
        onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef != null) {
            // Get the NFC tag ID
            tagId = ndef.additionalData['identifier']
                ?.map((e) => e.toRadixString(16))
                .join();
          }

        //  await NfcManager.instance.stopSession();
        },
      );

      // Wait for the tag ID to be captured
      while (tagId == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Return the detected NFC tag ID
      return tagId!;
    } on Exception catch (e) {
      // Handle any NFC-related errors
      throw Exception('An NFC error occurred: $e');
    } catch (e) {
      // Handle any other unexpected errors
      throw Exception('An unexpected error occurred: $e');
    } finally {
      // Ensure the session is stopped even in case of an error
    //  NfcManager.instance.stopSession();
    }
  }
}
