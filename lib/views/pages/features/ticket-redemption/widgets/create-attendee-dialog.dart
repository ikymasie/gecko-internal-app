import 'package:flutter/material.dart';
import 'package:gecko_internal/model/user.dart';
import 'package:gecko_internal/services/admin-api.dart';
import 'package:lottie/lottie.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CreateAttendeeDialog extends StatefulWidget {
  final Function(AttendeeUser newUser) onAccountCreated;
  CreateAttendeeDialog({required this.onAccountCreated});

  @override
  _CreateAttendeeDialogState createState() => _CreateAttendeeDialogState();
}

class _CreateAttendeeDialogState extends State<CreateAttendeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String initialCountry = 'BW';
  PhoneNumber number = PhoneNumber(isoCode: 'BW');

  bool _isLoading = false;
  String? _errorMessage;

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple email regex validation
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Phone number validation
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    return null;
  }

  // Name validation
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // Create attendee method using AdminApi
  Future<void> _createAttendee() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newUser = await AdminApi().createAttendee(
          _nameController.text, _phoneController.text, _emailController.text);
      setState(() {
        _isLoading = false;
      });
      widget.onAccountCreated(newUser);
      Navigator.of(context).pop(newUser); // Return new user after success
    } catch (e) {
      setState(() {
        _isLoading = false;
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
            // Dialog Title
            Text(
              'Create New Attendee',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Show Lottie animation while loading
            if (_isLoading)
              Lottie.asset('assets/animation/loading.json', height: 150),

            // Show error message
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),

            // Form to collect name, email, and phone
            if (!_isLoading)
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateName,
                    ),
                    SizedBox(height: 10),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 10),
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      validator: _validatePhone,
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: false, 
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phoneController,
                      formatInput: true,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                    // Phone number field

                    SizedBox(height: 20),

                    // Submit button
                    ElevatedButton(
                      onPressed: _createAttendee,
                      child: Text('Create Attendee'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
