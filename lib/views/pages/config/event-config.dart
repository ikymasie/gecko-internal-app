import 'package:flutter/material.dart';
import 'package:gecko_internal/theme.dart';
import 'package:gecko_internal/views/pages/config/location-config.dart';
import 'package:lottie/lottie.dart';
import '../../../model/event.dart';
import '../../../model/user.dart';
import '../../widgets/bezierContainer.dart'; // Import your BezierContainer widget
import '../../../services/admin-api.dart'; // Import your Admin API

class EventConfig extends StatefulWidget {
  final AdminUser adminUser; // AdminUser passed to the page

  EventConfig({required this.adminUser});

  @override
  _EventConfigState createState() => _EventConfigState();
}

class _EventConfigState extends State<EventConfig> {
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = true;
  // ignore: unused_field
  String _searchQuery = '';
  final api = new AdminApi();

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch events when the widget is initialized
  }

  // Fetch all events using the Admin API
  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Event> events = await api.getAllEvents();
      debugPrint('Events ${events.length}');
      setState(() {
        _events = events;
        _filteredEvents = events; // Initialize the filtered list
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching events: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search events by name
  void _searchEvents(String query) {
    setState(() {
      _searchQuery = query;
      _filteredEvents = _events
          .where(
              (event) => event.name.toLowerCase().contains(query.toLowerCase()))
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
          const Text(
            "Search Events",
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
            onChanged: _searchEvents,
          ),
        ],
      ),
    );
  }

  // Display the events in a list
  Widget _eventList() {
    return Expanded(
      child: _filteredEvents.isEmpty
          ? const Center(child: Text('No events found'))
          : ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return Card(
                    elevation: 8,
                    child: Container(
                        height: 74,
                        child: ListTile(
                          title: Text(event.name,
                              style: TextStyle(
                                  color: GeckoTheme.theme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            '${event.description}',
                            style:
                                TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            size: 13,
                            color: Colors.black38,
                          ),
                          onTap: () {
                            print('Event tapped: ${event.name}');
                                Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationConfig(adminUser: widget.adminUser, event: event),
                            ),
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
          text: 'E',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 16, 87, 228)),
          children: [
            TextSpan(
              text: 'ven',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ts',
              style: TextStyle(
                  color: Color.fromARGB(255, 16, 87, 228), fontSize: 30),
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
              top: height * -.22,
              right: -MediaQuery.of(context).size.width * .5,
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
                              ))// Show a loading indicator when fetching events
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
