import 'package:flutter/material.dart';
import 'package:gecko_internal/model/location.dart';
import 'package:gecko_internal/model/station.dart';
import 'package:gecko_internal/theme.dart';
import 'package:gecko_internal/views/pages/staff-login.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../model/event.dart';
import '../../../model/user.dart';
import '../../../utils/permission-manager.dart';
import '../../widgets/bezierContainer.dart'; // Import your BezierContainer widget
import '../../../services/admin-api.dart'; // Import your Admin API

class StationsConfig extends StatefulWidget {
  final AdminUser adminUser; // AdminUser passed to the page
  final Event event; // AdminUser passed to the page
  final Location location;
  StationsConfig(
      {required this.adminUser, required this.event, required this.location});

  @override
  _StationsConfigState createState() => _StationsConfigState();
}

class _StationsConfigState extends State<StationsConfig> {
  List<Station> _stations = [];
  List<Station> _filteredStations = [];
  final permissionManager = PermissionManager();
  final List<Permission> permissionsToRequest = [
    Permission.locationAlways,
    Permission.sensors,
    Permission.manageExternalStorage,
    Permission.camera,
    Permission.location,
  ];

  bool _isLoading = true;
  // ignore: unused_field
  String _searchQuery = '';
  final api = new AdminApi();

  @override
  void initState() {
    super.initState();
    _fetchStations(); // Fetch events when the widget is initialized
  }

  // Fetch all events using the Admin API
  Future<void> _fetchStations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Station> stations =
          await api.getStationsByLocation(widget.location.id);
      debugPrint('Stations ${stations.length}');
      setState(() {
        _stations = stations;
        _filteredStations = stations; // Initialize the filtered list
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching stations: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search events by name
  void _searchLocations(String query) {
    setState(() {
      _searchQuery = query;
      _filteredStations = _stations
          .where((event) =>
              event.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Back button (similar to AdminLoginPage)
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

  // Search bar widget (similar to AdminLoginPage entry fields)
  Widget _searchField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Search Stations within " + widget.location.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            onChanged: _searchLocations,
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Container(
      height: 40,
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child: SizedBox()),
          Text(
            value,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _getTypeRow(Station station) {
    switch (station.type) {
      case 'top-up':
        var text = '';
        return _row("", text);
      case 'check-in':
        return _row("Allowed Tickets",
            widget.location.accessLevelIds.length.toString());
      case 'ticket-redemption':
        var text = '';
        for (var i = 0; i < widget.event.ticketTypes!.length; i++) {
          var type = widget.event.ticketTypes![i];
          text += "${type.name}\n";
        }
        return _row("Available Tickets", text);
      default:
        return _row("", "");
    }
  }

  // Display the events in a list
  Widget _eventList() {
    return Expanded(
      child: _filteredStations.isEmpty
          ? const Center(child: Text('No stations found'))
          : ListView.builder(
              itemCount: _filteredStations.length,
              itemBuilder: (context, index) {
                final event = _filteredStations[index];
                return Card(
                    elevation: 8,
                    child: Container(
                        height: 74,
                        child: ListTile(
                          title: Text(event.name!,
                              style: TextStyle(
                                  color: GeckoTheme.theme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            'Type: ${event.type} station \n',
                            style:
                                TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            size: 13,
                            color: Colors.black38,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize
                                        .min, // This ensures the bottom sheet takes up minimal height
                                    children: [
                                      Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "You are about to configure this device as a",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black45,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              event.type.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: GeckoTheme
                                                      .theme.primaryColor,
                                                  fontSize: 22),
                                            ),
                                            Text(
                                              "Station",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black45,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.black12,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      _row('Event', widget.event.name),
                                      _row('Location/Area',
                                          widget.location.name),
                                      _row('Station', event.name ?? ''),
                                      SizedBox(height: 10),
                                      Divider(
                                        height: 1,
                                        color: Colors.black12,
                                      ),
                                      _getTypeRow(event),
                                      SizedBox(height: 10),
                                      Divider(
                                        height: 1,
                                        color: Colors.black12,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Map<Permission, PermissionStatus>
                                              statuses = await permissionManager
                                                  .checkAndRequestPermissions(
                                                      permissionsToRequest);

                                          // Check the statuses

                                          if (statuses[Permission.camera]!
                                              .isGranted) {
                                            print("Camera Permission granted.");
                                            // Proceed with Camera-related operations
                                          } else {
                                            print("Camera Permission denied.");
                                          }

                                          if (statuses[Permission.location]!
                                              .isGranted) {
                                            print(
                                                "Location Permission granted.");
                                            // Proceed with Location-related operations
                                            Navigator.pop(
                                                context); // Close the bottom sheet
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffLoginPage(
                                                    adminUser: widget.adminUser,
                                                    event: widget.event,
                                                    location: widget.location,
                                                    station: event,
                                                  ),
                                                ));
                                          } else {
                                            print(
                                                "Location Permission denied.");
                                          }
                                        },
                                        child: Text('Confirm'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )));
              },
            ),
    );
  }

  // Title widget (similar to AdminLoginPage title)
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          text: 'St',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 91, 144, 248)),
          children: [
            TextSpan(
              text: 'ati',
              style: TextStyle(
                  color: Color.fromARGB(255, 241, 241, 241), fontSize: 30),
            ),
            TextSpan(
              text: 'ons',
              style: TextStyle(
                  color: Color.fromARGB(255, 91, 144, 248), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: height * -.12,
              right: -MediaQuery.of(context).size.width * .37,
              child: Hero(
                  tag: 'main_banner',
                  child:
                      const BezierContainer()), // Your custom background widget
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Container(
                    height: height,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .12),
                        _title(),
                        const SizedBox(height: 30),
                        _searchField(),
                        const SizedBox(height: 20),
                        _isLoading
                            ? Expanded(
                                child: Center(
                                child: SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: LottieBuilder.asset(
                                    'assets/animation/loading.json',
                                    repeat: true,
                                  ),
                                ),
                              )) // Show a loading indicator when fetching events
                            : _eventList(),
                        const SizedBox(height: 20),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
