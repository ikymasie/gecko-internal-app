import 'package:flutter/material.dart';
import '../../services/auth-service.dart';
import '../../utils/global-loader.dart';

class AuthenticationDialog extends StatefulWidget {
  final VoidCallback onCancel; 
  AuthenticationDialog({required this.onCancel});

  @override
  _AuthenticationDialogState createState() => _AuthenticationDialogState();
}

class _AuthenticationDialogState extends State<AuthenticationDialog> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final auth = AuthService();
  final loader = GlobalLoader();

  // Method to handle the login process
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    loader.showLoader(context, lottieAsset: 'assets/animation/loading.json', backgroundColor: Colors.white);

    try {
      // Attempt to log in using the AuthService
      var account = await auth.loginAdmin(email, password);
      if (account.published == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Disabled')),
        );
        loader.hideLoader();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission Granted!'),
      ));
      loader.hideLoader();

      Navigator.of(context).pop(true); // Return true to parent when login succeeds

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication failed: $error'),
      ));
      loader.hideLoader();
    }
  }

  // Entry field widget for email and password
  Widget _entryField(String title, {bool isPassword = false, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          TextField(
            obscureText: isPassword,
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Title
            Text(
              "Authentication Required",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Email and password fields
            _entryField("Email", controller: _emailController),
            _entryField("Password", isPassword: true, controller: _passwordController),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    widget.onCancel(); // Call the onCancel function from the parent
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _login, // Trigger the login function
                  child: Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
