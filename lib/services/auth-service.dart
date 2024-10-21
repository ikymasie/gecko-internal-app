import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart' as model;
import 'admin-api.dart'; 

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AdminApi _adminApi = AdminApi();  // Replace with your base URL

  // Function to login admin with email and password
  Future<model.AdminUser> loginAdmin(String email, String password) async {
    try {
      // Sign in with email and password using Firebase Auth
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      print(user);
      if (user != null) {
        // After successful login, fetch admin account details using the Admin API
        print('FETCHING ACOUNT: :LOGIN SUCCESS');
        final adminData = await _adminApi.getAccountById<model.AdminUser>(user.uid);  // Assuming the UID is used as the account ID
        print('RESP: $adminData');
        return adminData;  // Return AdminUser instance
      } else {
        throw Exception('Failed to login. No user found.');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }
      throw Exception(errorMessage);  // Throw an exception with an appropriate message
    } catch (e) {
      // Any other errors (e.g., issues fetching the admin data)
      print('$e');
      throw Exception('An unexpected error occurred: $e');
    }
  }


  // Function to login staff with email and password
  Future<model.StaffUser> loginStaff(String email, String password) async {
    try {
      // Sign in with email and password using Firebase Auth
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // After successful login, fetch staff account details using the Admin API
        final staffData = await _adminApi.getAccountById<model.StaffUser>(user.uid);  // Assuming the UID is used as the account ID
        return staffData;  // Return StaffUser instance
      } else {
        throw Exception('Failed to login. No user found.');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No staff user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }
      throw Exception(errorMessage);  // Throw an exception with an appropriate message
    } catch (e) {
      // Any other errors (e.g., issues fetching the staff data)
      throw Exception('An unexpected error occurred: $e');
    }
  }
  // Function to sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
