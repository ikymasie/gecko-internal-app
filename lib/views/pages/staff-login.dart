import 'package:flutter/material.dart';
import 'package:gecko_internal/model/station.dart';
import 'package:gecko_internal/views/pages/features/check-in/access-control.dart';
import 'package:gecko_internal/views/pages/features/ticket-redemption/available-tickets-list.dart';
import 'package:gecko_internal/views/pages/features/top-up/top-up-screen.dart';
import 'package:gecko_internal/views/widgets/authentication-dialog.dart';
import '../../model/event.dart';
import '../../model/location.dart';
import '../../model/user.dart';
import '../../utils/nfc-listener.dart';
import '../widgets/bezierContainer.dart';
import '../../services/auth-service.dart'; // Adjust the import based on your actual project structure.
import '../../utils/global-loader.dart';

class StaffLoginPage extends StatefulWidget {
  final AdminUser adminUser; // AdminUser passed to the page
  final Event event; // AdminUser passed to the page
  final Location location;

  final Station station;

  StaffLoginPage(
      {Key? key,
      required this.adminUser,
      required this.location,
      required this.event,
      required this.station})
      : super(key: key);

  @override
  _StaffLoginPageState createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<StaffLoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final auth = new AuthService();
  final loader = new GlobalLoader();
  final nfc = new NFCListener();
  bool didPop = false;
  Future<bool> _onBackPressed(bool pop, dynamic results) async {
    pop = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        return AuthenticationDialog(
          onCancel: () {
            // Handle cancel action
            print("Login canceled.");
            pop = false;
          },
          onSuccess: () {
            // Handle success action
            print("Login successful.");
            pop = true;
            Navigator.of(context).pop(true);
          },
        );
      },
    );

    return pop;
  }

  Future<void> _init() async {
    try {
      var listenr = await nfc.listenForNFCTap();
      print('Tag found $listenr');
      _init();
    } catch (e) {
      debugPrint('Err: $e');
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: isPassword,
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          // Show some error message, e.g., using a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please enter both email and access code.'),
          ));
          return;
        }

        // Show the global loader before attempting login
        loader.showLoader(context,
            lottieAsset: 'assets/animation/loading.json',
            backgroundColor: Colors.white);

        try {
          // Attempt to log in using the AuthService
          var account = await auth.loginStaff(email, password);
          if (account.published == false) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Account Disabled'),
            ));
            return;
          }
          var allowed = false;
          for (var i = 0; i < widget.station.staffIds.length; i++) {
            var staffId = widget.station.staffIds[i];
            if (staffId == account.id) {
              allowed = true;
              break;
            }
          }
          if (allowed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Lets get to work ${account.name}!'),
            ));
            navigateToFeature(account);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  '${account.name}, you have NOT been assigned to this station!'),
            ));
          }
        } catch (error) {
          // Show an error message (example using SnackBar)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login failed: $error'),
          ));
        } finally {
          // Hide the loader after attempting login
          loader.hideLoader();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 30, 21, 107),
                Color.fromARGB(255, 43, 155, 247)
              ]),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
              text: 'St',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 16, 87, 228)),
              children: [
                TextSpan(
                  text: 'af',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextSpan(
                  text: 'f',
                  style: TextStyle(
                      color: Color.fromARGB(255, 16, 87, 228), fontSize: 30),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
              text: 'Lo',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 27, 29, 31)),
              children: [
                TextSpan(
                  text: 'g',
                  style: TextStyle(
                      color: Color.fromARGB(255, 16, 87, 228), fontSize: 20),
                ),
                TextSpan(
                  text: 'in',
                  style: TextStyle(
                      color: Color.fromARGB(255, 27, 29, 31), fontSize: 20),
                ),
              ]),
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Hero(
            tag: 'main_input',
            child: _entryField("Email", controller: _emailController)),
        _entryField("Access Code",
            isPassword: true, controller: _passwordController),
      ],
    );
  }

  void navigateToFeature(StaffUser user) {
    switch (widget.station.type) {
      case 'ticket-redemption':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AvailableTicketsList(
                adminUser: widget.adminUser,
                event: widget.event,
                location: widget.location,
                station: widget.station,
                staffUser: user,
              ),
            ));
        break;
      case 'top-up':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopUpPage(
                adminUser: widget.adminUser,
                event: widget.event,
                location: widget.location,
                station: widget.station,
                staffUser: user,
              ),
            ));
        break;
      case 'check-in':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccessControlPage(
                event: widget.event,
                location: widget.location,
                station: widget.station,
                staffUser: user,
              ),
            ));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PopScope(
        canPop: didPop,
        onPopInvokedWithResult: _onBackPressed,
        child: Scaffold(
            body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child:
                      Hero(tag: 'main_banner', child: const BezierContainer())),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      const SizedBox(height: 50),
                      _emailPasswordWidget(),
                      const SizedBox(height: 20),
                      _submitButton(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: const Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      _divider()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
