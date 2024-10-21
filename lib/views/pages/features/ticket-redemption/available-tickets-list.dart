import 'package:flutter/material.dart';
import 'package:gecko_internal/model/location.dart';
import 'package:gecko_internal/model/station.dart';
import 'package:gecko_internal/model/ticket-type.dart';
import 'package:gecko_internal/services/staff-api.dart';
import 'package:gecko_internal/theme.dart';
import 'package:gecko_internal/utils/global-loader.dart';
import 'package:gecko_internal/views/widgets/nfc-listening-dialog.dart';
import 'package:lottie/lottie.dart';
import '../../../../model/event.dart';
import '../../../../model/user.dart';
import '../../../widgets/bezierContainer.dart';
import 'widgets/create-attendee-dialog.dart';
import 'widgets/user-search-bottom-sheet.dart'; // Import your BezierContainer widget
import 'package:gecko_internal/views/widgets/customDialog.dart';

class AvailableTicketsList extends StatefulWidget {
  final AdminUser adminUser; // AdminUser passed to the page
  final StaffUser staffUser; // AdminUser passed to the page
  final Event event; // AdminUser passed to the page
  final Location location;
  final Station station;

  AvailableTicketsList(
      {required this.adminUser,
      required this.event,
      required this.location,
      required this.station,
      required this.staffUser});

  @override
  _AvailableTicketsListState createState() => _AvailableTicketsListState();
}

class _AvailableTicketsListState extends State<AvailableTicketsList> {
  List<TicketType> _ticketTypes = [];
  List<TicketType> _filteredTicketTypes = [];

  late TicketType _selectedTicket;
  bool _isLoading = true;
  // ignore: unused_field
  String _searchQuery = '';
  final api = new StaffApi();
  final loader = new GlobalLoader();

  @override
  void initState() {
    super.initState();
    _fetchStations(); // Fetch events when the widget is initialized
  }

  onAssignTag(AttendeeUser user) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return NFCListeningDialog(
          instruction: "Please tap your NFC load ticket",
          onTapComplete: (String nfcId) {
            print(
                "TAG: ${nfcId} | Ticket: ${_selectedTicket.name} | For : ${user.name}");
            linkNFCTag(nfcId, user);
          },
        );
      },
    ).then((tagId) {
      if (tagId != null) {
        // Handle the NFC tag ID here
        print('NFC Tag ID: $tagId');
      }
    });
  }

  linkNFCTag(String nfcId, AttendeeUser user) async {
    try {
      loader.showLoader(context,
          message:
              'Creating NFC ${_selectedTicket.name} (${_selectedTicket.id}) for ${user.name}.... please wait');
      var ticketData = {
        "userId": user.id,
        "eventId": widget.event.id,
        "staffId": widget.staffUser.id,
        "ticketType": _selectedTicket.id
      };

      var res = await api.createTicketForAttendee(ticketData);

      loader.updateMessage(
          "Assigning tag to event locations.... this wont't take long");
          var TICKET_ID=  res['id'];
      await api.linkNFCTagToAttendee(
          user.id, nfcId, res['id'], widget.staffUser.id);
      loader.hideLoader();
      showMessage("assets/animation/success.json", "Ticket Linked",
          "Please hand the NFC tag over to ${user.name} and prepare to handle another ticket");
      // well done!
    } catch (e) {
      loader.hideLoader();
      showMessage("assets/animation/error.json", "Oops!", "Description: $e");
    } finally {}
  }
  // Fetch all events using the Admin API

  showMessage(String asset, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow tapping outside to dismiss the dialog
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          description: description,
          lottieAsset: asset, // Replace with your Lottie asset path
        );
      },
    );
  }

  Future<void> _fetchStations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      setState(() {
        _ticketTypes = widget.event.ticketTypes!;
        _filteredTicketTypes =
            widget.event.ticketTypes!; // Initialize the filtered list
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching ticket types: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search events by name

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


  // Display the events in a list
  Widget _eventList() {
    return Expanded(
      child: _filteredTicketTypes.isEmpty
          ? const Center(child: Text('No Loadable tickets found'))
          : ListView.builder(
              itemCount: _filteredTicketTypes.length,
              itemBuilder: (context, index) {
                final type = _filteredTicketTypes[index];
                return Card(
                    elevation: 8,
                    child: Container(
                        height: 74,
                        child: ListTile(
                          title: Text(type.name,
                              style: TextStyle(
                                  color: GeckoTheme.theme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            'Price: ${type.price.toStringAsFixed(2)} | Initial Balance: ${type.initialBalance.toStringAsFixed(2)}',
                            style:
                                TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            size: 13,
                            color: Colors.black38,
                          ),
                          onTap: () {
                            setState(() {
                              _selectedTicket = type;
                              //show modal to search for a new customer using their phone number or email address
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled:
                                    true, // Make sure the bottom sheet can expand fully
                                builder: (context) {
                                  return UserSearchBottomSheet(
                                    ticketToLoad: type,
                                    onAttendeeSelected: (user) {
                                      print('New Attendee Created: ${user.id}');

                                      Navigator.of(context).pop();
                                      onAssignTag(user);
                                    },
                                    onCreateAttendee: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CreateAttendeeDialog(
                                            onAccountCreated:
                                                (AttendeeUser newUser) {
                                              // Navigate to NFC Screen
                                              print(
                                                  'New Attendee Created: ${newUser.id}');

                                              Navigator.of(context).pop();
                                              onAssignTag(newUser);
                                              //show nfc loading screen here
                                            },
                                          );
                                        },
                                      ).then((result) {
                                        if (result != null) {
                                          // Handle the created AttendeeUser (result)
                                          print(
                                              'New Attendee Created: ${result.name}');
                                        }
                                      });
                                    },
                                  );
                                },
                              );
                            });
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
          text: 'Ti',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 91, 144, 248)),
          children: [
            TextSpan(
              text: 'cke',
              style: TextStyle(
                  color: Color.fromARGB(255, 241, 241, 241), fontSize: 30),
            ),
            TextSpan(
              text: 'ts',
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
              top: height * -.2,
              right: -MediaQuery.of(context).size.width * .07,
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
